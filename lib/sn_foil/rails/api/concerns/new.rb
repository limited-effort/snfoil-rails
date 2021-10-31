# frozen_string_literal: true

require 'active_support/concern'
require_relative '../concerns/process_pagination'

module SnFoil
  module Rails
    module API
      module New
        extend ActiveSupport::Concern

        included do
          endpoint :new, with: :new_endpoint
        end

        def new_endpoint(**options)
          @object = options[:object]

          render options[:controller_action]
        end
      end
    end
  end
end