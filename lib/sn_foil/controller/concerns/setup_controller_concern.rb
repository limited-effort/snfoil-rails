# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Controller
    module Concerns
      module SetupControllerConcern
        extend ActiveSupport::Concern

        class_methods do
          attr_reader :i_context

          def context(klass = nil)
            @i_context = klass
          end
        end

        def context(**options)
          options[:context] || self.class.i_context
        end

        def setup_options(**options)
          options = inject_params(**options)
          options = inject_id(**options)
          options = inject_includes(**options)
          inject_controller_action(**options)
        end

        def current_context(**options)
          @current_context ||= context(**options).new(context_user)
        end

        protected

        def pundit_not_authorized
          head :forbidden
        end

        private

        # Grab the rails params and inject them into the options
        def inject_params(**options)
          return options if options[:params]
          return options unless params

          options[:params] = params.to_unsafe_h.deep_symbolize_keys
          options[:controller_params] = options[:params]
          options
        end

        def inject_id(**options)
          return options if options[:id]

          options[:id] = id if defined? id
          options[:id] ||= options[:params][:id]
          options
        end

        def inject_includes(**options)
          return options if options[:include]
          return options unless options.dig(:params, :include)

          options[:include] = options.dig(:params, :include)
                                     .split(',')
                                     .map { |item| item.underscore.to_sym }
          options
        end

        def inject_controller_action(**options)
          return options if options[:controller_action]
          return options unless options.dig(:params, :action)

          options[:controller_action] = options[:params][:action]
          options
        end

        def context_user
          return current_user if defined? current_user
        end
      end
    end
  end
end
