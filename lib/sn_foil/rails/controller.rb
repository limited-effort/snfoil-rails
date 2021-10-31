# frozen_string_literal: true

require 'active_support/concern'
require_relative 'concerns/inject_controller_params'
require_relative 'concerns/inject_deserialized'
require_relative 'concerns/inject_id'
require_relative 'concerns/inject_includes'
require_relative 'concerns/process_context'

module SnFoil
  module Rails
    module Controller
      extend ActiveSupport::Concern

      included do
        include SnFoil::Context
        include InjectControllerParams
        include InjectDeserialized
        include InjectId
        include InjectIncludes
        include ProcessContext
      end

      class_methods do
        attr_reader :snfoil_endpoints, :snfoil_context, :snfoil_deserializer, :snfoil_serializer

        def context(klass = nil)
          @snfoil_context = klass
        end

        def serializer(klass = nil)
          @snfoil_serializer = klass
        end

        def deserializer(klass = nil)
          @snfoil_deserializer = klass
        end

        def endpoint(name, with: nil, **options, &block)
          (@snfoil_endpoints ||= {})[name] =
            options.merge(controller_action: name, context_action: options[:context_action] || name,
                          deserialize: deserialize, method: with, block: block)

          interval "setup_#{name}"
          interval "process_#{name}"

          define_default_hooks(name)
          define_endpoint_method(name)
        end
      end

      def entity
        return current_entity if defined? current_entity
        return current_user if defined? current_user
      end

      protected

      class_methods do
        def define_default_hooks(name)
          send("setup_#{name}", :inject_controller_params)
          send("setup_#{name}", :inject_deserialized_params)
          send("setup_#{name}", :inject_id)
          send("setup_#{name}", :inject_includes)
          send("process_#{name}", :process_context)
        end

        def define_endpoint_method(name)
          define_method(name) do |**options|
            options = options.merge this.class.snfoil_endpoints[name]
            options = run_interval("setup_#{name}", **options)
            options = run_interval("process_#{name}", **options)
            exec_render(**options)
          end
        end

        private

        def exec_render(method: nil, **options, &block)
          return send(method, **options) if method

          instance_exec block, **options
        end
      end
    end
  end
end
