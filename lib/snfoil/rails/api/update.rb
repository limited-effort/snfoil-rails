# frozen_string_literal: true

require_relative '../concerns/inject_deserialized'
require_relative '../concerns/inject_id'
require_relative '../concerns/inject_includes'
require_relative '../concerns/inject_request_params'
require_relative '../concerns/process_context'
require_relative '../controller'

module SnFoil
  module Rails
    module API
      module Update
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          include InjectDeserialized
          include InjectId
          include InjectIncludes
          include InjectRequestParams
          include ProcessContext

          endpoint :update, with: :render_update

          setup_update with: :inject_id
          setup_update with: :inject_request_params
          setup_update with: :inject_deserialized_params
          setup_update with: :inject_includes

          process_update with: :process_context

          def render_update(**options)
            if options[:object].errors.empty?
              render json: serialize(options[:object], **options), status: :ok
            else
              render json: options[:object].errors, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
