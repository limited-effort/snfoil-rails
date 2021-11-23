# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module InjectParams
      extend ActiveSupport::Concern

      def inject_controller_params(**options)
        return options if options[:params]
        return options unless params

        options[:params] = params.to_unsafe_h.deep_symbolize_keys
        options[:controller_params] = options[:params]
        options
      end
    end
  end
end
