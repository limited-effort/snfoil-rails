# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module SSR
      module Show
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          endpoint :show, with: :show_endpoint
        end

        def show_endpoint(**options)
          @object = options[:object]

          render options[:controller_action]
        end
      end
    end
  end
end
