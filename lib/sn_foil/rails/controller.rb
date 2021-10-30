# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module Controller
      extend ActiveSupport::Concern

      included do
        include SnFoil::Context
      end

      class_methods do
        attr_reader :snfoil_endpoints, :snfoil_context

        def context(klass = nil)
          @snfoil_context = klass
        end

        def endpoint(name, **options)
          assign_options(name, **options)
          define_intervals(name)
          define_controller_transforms(name)
          define_endpoint_method(name)
        end
      end

      def inject_params(**options)
        return options if options[:params]
        return options unless params

        options[:params] = params.to_unsafe_h.deep_symbolize_keys
        options[:controller_params] = options[:params]
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

      protected

      class_methods do
        def assign_options(name, deserialize: false, **options)
          (@snfoil_endpoints ||= {})[name] = options.merge(
            controller_action: name,
            deserialize: deserialize
          )
        end

        def define_controller_transforms(name)
          send("setup_#{name}", :inject_params)
          send("setup_#{name}", :inject_deserialized_params)
          send("setup_#{name}", :inject_id)
          send("setup_#{name}", :inject_includes)
        end


        def define_intervals(name)
          interval "setup_#{name}"
          interval "process_#{name}"
          interval "render_#{name}"
        end

        def define_endpoint_method(name)
          define_method(name) do |**options|
            options = options.merge this.class.snfoil_endpoints[name]
            options = run_interval("setup_#{name}", **options)
            options = run_interval("process_#{name}", **options)
            run_interval("render_#{name}", **options)
          end
        end
      end
    end
  end
end
