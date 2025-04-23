# frozen_string_literal: true

# Copyright 2021 Matthew Howes

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'active_support/concern'
require 'snfoil/searcher'

module SnFoil
  module Rails
    module Searcher
      extend ActiveSupport::Concern
      ASC = 'ASC'
      DESC = 'DESC'

      included do
        include SnFoil::Searcher

        # patch the additional search capabilities into the method
        def search(params = {})
          filtered_scope = super(**params)
          additional_search(filtered_scope, params)
        end
      end

      class_methods do
        attr_reader :snfoil_include_params, :snfoil_order_method, :snfoil_order_block,
                    :snfoil_order_by_attr, :snfoil_order_by_direction, :snfoil_is_distinct

        def order(method = nil, &block)
          @snfoil_order_method = method
          @snfoil_order_block = block
        end

        def order_by(attr, direction = nil)
          @snfoil_order_by_attr = attr
          @snfoil_order_by_direction = direction
        end

        def distinct(bool = true) # rubocop:disable Style/OptionalBooleanParameter --- reason: class configuration looks better this way
          @snfoil_is_distinct = bool
        end

        def includes(*array)
          @snfoil_include_params ||= [] # create new array if none exists
          @snfoil_include_params |= array # combine unique elements of both arrays
        end
      end

      def order_by(params = {})
        if params[:order_by].present?
          params[:order_by] = params[:order_by].to_s.underscore
          return params[:order_by].to_sym if model.attribute_names.include?(params[:order_by])
        end

        self.class.snfoil_order_by_attr || :id
      end

      def order(params = {})
        if params[:order].present?
          params[:order] = params[:order].to_s.upcase
          return params[:order] if params[:order].eql?(ASC) || params[:order].eql?(DESC)
        end

        self.class.snfoil_order_by_direction || ASC
      end

      private

      def additional_search(filtered_scope, params = {})
        filtered_scope = apply_order(filtered_scope, params)
        filtered_scope = apply_includes(filtered_scope)
        apply_distinct(filtered_scope, params)
      end

      def apply_includes(filtered_scope)
        return filtered_scope unless self.class.snfoil_include_params

        filtered_scope.includes(*self.class.snfoil_include_params)
      end

      def apply_order(filtered_scope, params)
        return order_method(filtered_scope, params) if order_method_present?
        return order_block(filtered_scope, params) if order_block_present?

        if params[:order_by].blank? && params[:order].blank?
          filtered_scope.order(order_by => order)
        else
          filtered_scope.order(order_by(params) => order(params))
        end
      end

      def order_method_present?
        self.class.snfoil_order_method.present?
      end

      def order_block_present?
        self.class.snfoil_order_block.present?
      end

      def order_method(filtered_scope, params)
        send(self.class.snfoil_order_method, filtered_scope, params)
      end

      def order_block(filtered_scope, params)
        instance_exec filtered_scope, params, &self.class.snfoil_order_block
      end

      def apply_distinct(filtered_scope, params)
        return filtered_scope unless self.class.snfoil_is_distinct || params[:distinct] == true

        filtered_scope.distinct
      end
    end
  end
end
