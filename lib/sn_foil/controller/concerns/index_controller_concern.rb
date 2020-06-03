# frozen_string_literal: true

require 'active_support/concern'
require_relative 'setup_controller_concern'

module SnFoil
  module Controller
    module Concerns
      module IndexControllerConcern
        extend ActiveSupport::Concern

        included do
          include SetupControllerConcern
        end

        def index(**options)
          options = setup_index(**options)
          results = process_index(**options)
          render_index(results, **options)
        end

        def setup_index(**options)
          setup_options(**options)
        end

        def process_index(**options)
          current_context(**options).index(options)
        end

        def render_index(results, **options)
          render paginate(results, **options), meta: meta(results, options)
        end

        def paginate(results, **options)
          return results unless results.respond_to?(:page)

          results.page(page(**options))
                 .per(per_page(**options))
        end

        def page(**options)
          (options.dig(:params, :page) || 1).to_i
        end

        def per_page(**options)
          per_page_param = (options.dig(:params, :per_page) || 10).to_i
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
      end
    end
  end
end
