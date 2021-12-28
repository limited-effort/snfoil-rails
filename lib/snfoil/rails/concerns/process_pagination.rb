# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module ProcessPagination
      extend ActiveSupport::Concern

      def paginate(results, **options)
        return results unless results.respond_to?(:page)

        results.page(page(**options))
               .per(per_page(**options))
      end

      def page(**options)
        (options.dig(:controller_params, :page) || 1).to_i
      end

      def per_page(**options)
        per_page_param = (options.dig(:controller_params, :per_page) || 10).to_i
        return 1000 if per_page_param.zero? || per_page_param > 1000

        per_page_param
      end

      def meta(results, **options)
        results = paginate(results, **options)
        total_pages = results.respond_to?(:total_pages) ? results.total_pages : nil
        total_count = results.respond_to?(:total_count) ? results.total_count : nil

        {
          page: page(**options),
          pages: total_pages,
          total: total_count,
          per: per_page(**options)
        }
      end

      def process_pagination(**options)
        options[:object] = paginate(options[:object], **options)
        options[:meta] = meta(options[:object], **options)

        options
      end
    end
  end
end
