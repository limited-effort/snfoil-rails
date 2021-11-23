# frozen_string_literal: true

require 'active_support/concern'
require_relative 'setup_controller_concern'
require_relative 'change_controller_concern'

module SnFoil
  module Controller
    module Concerns
      module UpdateControllerConcern
        extend ActiveSupport::Concern

        included do
          include SetupControllerConcern
          include ChangeControllerConcern
        end

        def update(**options)
          options = setup_update(**options)
          model = process_update(**options)
          render_update(model, **options)
        end

        def setup_update(**options)
          setup_options(**options)
        end

        def process_update(**options)
          current_context(**options).update(**options)[:object]
        end

        def render_update(model, **options)
          render_change(model, **options)
        end
      end
    end
  end
end
