# frozen_string_literal: true

require 'active_support/concern'
require_relative 'setup_controller_concern'
require_relative 'change_controller_concern'

module SnFoil
  module Controller
    module Concerns
      module CreateControllerConcern
        extend ActiveSupport::Concern

        included do
          include SetupControllerConcern
          include ChangeControllerConcern
        end

        def create(**options)
          options = setup_create(**options)
          model = process_create(**options)
          render_create(model, **options)
        end

        def setup_create(**options)
          setup_options(**options)
        end

        def process_create(**options)
          current_context(**options).create(**options)[:object]
        end

        def render_create(model, **options)
          render_change(model, **options)
        end
      end
    end
  end
end
