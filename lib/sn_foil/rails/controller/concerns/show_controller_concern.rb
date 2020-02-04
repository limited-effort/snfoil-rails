# frozen_string_literal: true

require 'active_support/concern'
require_relative 'setup_controller_concern'

module SnFoil
  module Rails
    module Controller
      module Concerns
        module ShowControllerConcern
          extend ActiveSupport::Concern

          included do
            include SetupControllerConcern
          end

          def show(**options)
            options = setup_show(**options)
            model = process_show(**options)
            render_show(model, **options)
          end

          def setup_show(**options)
            setup_options(**options)
          end

          def process_show(**options)
            current_context(**options).show(**options)
          end

          def render_show(model, **_options)
            render model
          end
        end
      end
    end
  end
end
