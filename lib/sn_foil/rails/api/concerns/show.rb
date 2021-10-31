# frozen_string_literal: true

require 'active_support/concern'
require_relative '../concerns/process_pagination'

module SnFoil
  module Rails
    module API
      module Show
        extend ActiveSupport::Concern

        included do
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
