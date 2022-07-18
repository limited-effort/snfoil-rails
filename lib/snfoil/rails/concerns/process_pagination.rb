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

module SnFoil
  module Rails
    module ProcessPagination
      extend ActiveSupport::Concern

      def paginate(**options)
        return options[:object] unless options[:object].respond_to?(:page)

        options[:object].page(pagination_page(**options))
                        .per(pagination_per_page(**options))
      end

      def pagination_page(**options)
        (options.dig(:request_params, :page) || 1).to_i
      end

      def pagination_per_page(**options)
        per_page_param = (options.dig(:request_params, :per_page) || 10).to_i
        return 1000 if per_page_param.zero? || per_page_param > 1000

        per_page_param
      end

      def pagination_count(**options)
        options[:object].count if options[:object].respond_to? :count
      end

      def pagination_pages(**options)
        count = pagination_count(**options)
        per_page = pagination_per_page(**options)
        return unless count && per_page

        (count.to_f / per_page).ceil.to_i
      end

      def pagination_meta(**options)
        {
          page: pagination_page(**options),
          pages: pagination_pages(**options),
          total: pagination_count(**options),
          per: pagination_per_page(**options)
        }
      end

      def process_pagination(**options)
        options[:meta] = pagination_meta(**options)
        options[:object] = paginate(**options)

        options
      end
    end
  end
end
