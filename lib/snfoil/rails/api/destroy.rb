# frozen_string_literal: true

require_relative '../concerns/inject_id'
require_relative '../concerns/inject_request_params'
require_relative '../concerns/process_context'
require_relative '../controller'

module SnFoil
  module Rails
    module API
      module Destroy
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          include InjectId
          include InjectRequestParams
          include ProcessContext

          endpoint :destroy, with: :render_destroy

          setup_destroy with: :inject_id
          setup_destroy with: :inject_request_params

          process_destroy with: :process_context

          def render_destroy(**options)
            if options[:object].errors.empty?
              render json: {}, status: :no_content
            else
              render json: options[:object].errors, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
