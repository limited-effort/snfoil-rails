# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module ApiController
      extend ActiveSupport::Concern

      included do
        prepend SnFoil::Rails::Controller
      end

      class_methods do
        attr_reader :snfoil_serializer, :snfoil_deserializer

        def serializer(klass = nil)
          @snfoil_serializer = klass
        end

        def deserializer(klass = nil)
          @snfoil_deserializer = klass
        end

        def endpoint(name, **options)
          assign_options(name, **options)
          define_intervals(name)
          define_controller_transforms(name)
          define_api_controller_transforms(name)
          define_endpoint_method(name)
          define_render_method(name)
        end
      end

      def inject_deserialized_params(**options)
        return options unless options[:params].present? && options[:deserialize] == true

        deserializer = options.fetch(:deserializer) { self.class.snfoil_deserializer }
        return unless deserializer

        options[:params] = deserializer.new(options[:params], **options).to_h
        options
      end

      protected

      class_methods do
        def define_controller_transforms(name)
          send("setup_#{name}", :inject_deserialized_params)
        end

        def define_render_method(name)
          define_method("render_#{name}") do |**options|
          end
        end
      end
    end
  end
end
