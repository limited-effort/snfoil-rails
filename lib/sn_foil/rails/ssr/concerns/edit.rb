# frozen_string_literal: true

require 'active_support/concern'
require_relative '../concerns/process_pagination'

module SnFoil
  module Rails
    module SSR
      module Edit
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          endpoint :edit, with: :edit_endpoint
        end

        def edit_endpoint(**options)
          @object = options[:object]

          render options[:controller_action]
        end
      end
    end
  end
end
