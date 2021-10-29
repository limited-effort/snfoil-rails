# frozen_string_literal: true

require 'active_support/concern'
require 'sn_foil/searcher'

module SnFoil
  module Searcher
    extend ActiveSupport::Concern
    ASC = 'ASC'
    DESC = 'DESC'

    included do
      module_eval do
        alias_method :base_search, :search

        # patch the additional search capabilities into the method
        def search(params = {})
          filtered_scope = base_search(params)
          additional_search(filtered_scope, params)
        end
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

      def distinct(bool = true) # rubocop:disable Style/OptionalBooleanParameter reason: class configuration looks better this way
        @snfoil_is_distinct = bool
      end

      def includes(*array)
        @snfoil_include_params ||= [] # create new array if none exists
        @snfoil_include_params |= array # combine unique elements of both arrays
      end
    end

    def distinct?
      self.class.snfoil_is_distinct || false
    end

    def included_params
      self.class.snfoil_include_params
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
      return filtered_scope unless included_params

      filtered_scope.includes(*included_params)
    end

    def apply_order(filtered_scope, params)
      return order_method(filtered_scope, params) if order_method?
      return order_block(filtered_scope, params) if order_block?

      if params[:order_by].blank? && params[:order].blank?
        filtered_scope.order(order_by => order)
      else
        filtered_scope.order(order_by(params) => order(params))
      end
    end

    def order_method(filtered_scope, params)
      send(self.class.snfoil_order_method, filtered_scope, params)
    end

    def order_method?
      self.class.snfoil_order_method.present?
    end

    def order_block(filtered_scope, params)
      instance_exec filtered_scope, params, &self.class.snfoil_order_block
    end

    def order_block?
      self.class.snfoil_order_block.present?
    end

    def apply_distinct(filtered_scope, params)
      return filtered_scope unless distinct? || params[:distinct] == true

      filtered_scope.distinct
    end
  end
end
