# frozen_string_literal: true

require 'action_controller/api'
require_relative 'base'

module SnFoil
  module Controller
    class API < SnFoil::Controller::Base
      class << self
        attr_reader :i_serializer, :i_deserializer

        def serializer(klass = nil)
          @i_serializer = klass
        end

        def deserializer(klass = nil)
          @i_deserializer = klass
        end
      end

      def serializer(**options)
        options[:serializer] || self.class.i_serializer
      end

      def deserializer(**options)
        options[:deserializer] || self.class.i_deserializer
      end

      def setup_options(**options)
        inject_deserialized_params(super)
      end

      def setup_create(**options)
        super(**options.merge(deserialize: true))
      end

      def setup_update(**options)
        super(**options.merge(deserialize: true))
      end

      def render_change(model, **options)
        if model.errors.empty?
          render json: serializer(**options).new(model, **options).serializable_hash
        else
          render json: model.errors, status: :unprocessable_entity
        end
      end

      def render_destroy(model, **_options)
        if model.errors.empty?
          render json: {}, status: :no_content
        else
          render json: model.errors, status: :unprocessable_entity
        end
      end

      def render_index(results, **options)
        render json: serializer(**options).new(paginate(results, **options), **options, meta: meta(results, **options))
                                          .serializable_hash
      end

      def render_show(model, **options)
        render json: serializer(**options).new(model, **options).serializable_hash
      end

      private

      def inject_deserialized_params(**options)
        return options unless options[:params].present? && options[:deserialize] == true
        return options unless deserializer(**options)

        options[:params] = deserializer(**options).new(options[:params], **options).to_h
        options
      end
    end
  end
end
