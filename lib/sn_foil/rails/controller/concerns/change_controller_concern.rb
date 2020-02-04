# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module Controller
      module Concerns
        module ChangeControllerConcern
          extend ActiveSupport::Concern

          def render_change(model, **_options)
            if model.errors.empty?
              render model
            else
              render model.errors, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
