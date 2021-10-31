# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module InjectIncludes
      extend ActiveSupport::Concern

      def inject_includes(**options)
        return options if options[:include]
        return options unless options.dig(:params, :include)

        options[:include] = options.dig(:params, :include)
                                   .split(',')
                                   .map { |item| item.underscore.to_sym }
        options
      end
    end
  end
end
