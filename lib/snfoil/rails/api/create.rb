# frozen_string_literal: true

require_relative '../concerns/inject_deserialized'
require_relative '../concerns/inject_request_params'
require_relative '../concerns/process_context'
require_relative '../controller'

module SnFoil
  module Rails
    module API
      module Create
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          include InjectDeserialized
          include InjectIncludes
          include InjectRequestParams
          include ProcessContext

          endpoint :create, with: :render_create

          setup_create with: :inject_request_params
          setup_create with: :inject_deserialized_params
          setup_create with: :inject_includes

          process_create with: :process_context

          def render_create(**options)
            if options[:object].errors.empty?
              render json: serialize(options[:object], **options), status: :created
            else
              render json: options[:object].errors, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
