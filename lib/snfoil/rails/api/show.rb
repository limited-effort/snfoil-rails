# frozen_string_literal: true

require_relative '../concerns/inject_id'
require_relative '../concerns/inject_includes'
require_relative '../concerns/inject_request_params'
require_relative '../concerns/process_context'
require_relative '../controller'

module SnFoil
  module Rails
    module API
      module Show
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          include InjectId
          include InjectIncludes
          include InjectRequestParams
          include ProcessContext

          endpoint :show, with: :render_show

          setup_show with: :inject_id
          setup_show with: :inject_request_params
          setup_show with: :inject_includes

          process_show with: :process_context

          def render_show(**options)
            render json: serialize(options[:object], **options), status: :ok
          end
        end
      end
    end
  end
end
