# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module InjectRequestParams
      extend ActiveSupport::Concern

      def inject_request_params(**options)
        return options if options[:params]
        return options unless params

        options[:params] = params.to_unsafe_h.deep_symbolize_keys
        options[:request_params] = options[:params]
        options
      end
    end
  end
end
