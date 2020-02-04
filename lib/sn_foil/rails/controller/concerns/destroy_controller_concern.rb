# frozen_string_literal: true

require 'active_support/concern'
require_relative 'setup_controller_concern'

module SnFoil
  module Rails
    module Controller
      module Concerns
        module DestroyControllerConcern
          extend ActiveSupport::Concern

          included do
            include SetupControllerConcern
          end

          def destroy(**options)
            options = setup_destroy(**options)
            model = process_destroy(**options)
            render_destroy(model, **options)
          end

          def setup_destroy(**options)
            setup_options(**options)
          end

          def process_destroy(**options)
            current_context(**options).destroy(**options)
          end

          def render_destroy(model, **_options)
            if model.errors.empty?
              render nil
            else
              render model.errors, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
