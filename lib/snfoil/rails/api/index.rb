# frozen_string_literal: true

require_relative '../concerns/inject_includes'
require_relative '../concerns/inject_request_params'
require_relative '../concerns/process_context'
require_relative '../concerns/process_pagination'
require_relative '../controller'

module SnFoil
  module Rails
    module API
      module Index
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          include InjectIncludes
          include InjectRequestParams
          include ProcessContext
          include ProcessPagination

          endpoint :index, with: :render_index

          setup_index with: :inject_request_params
          setup_index with: :inject_includes

          process_index with: :process_context
          process_index with: :process_pagination

          def render_index(**options)
            render json: serialize(options[:object], **options), status: :ok
          end
        end
      end
    end
  end
end
