# frozen_string_literal: true

require_relative 'controller'

module SnFoil
  module Rails
    class APIController < ActionController::API
      include SnFoil::Controller

      class << self
        def endpoint(name, **options, &block)
          super(name,
                **options,
                context_action: options.fetch(:context_action, name),
                deserialize: options.fetch(:deserialize, true),
                &block)

          send("setup_#{name}", :inject_controller_params)
          send("setup_#{name}", :inject_deserialized_params)
          send("setup_#{name}", :inject_id)
          send("setup_#{name}", :inject_includes)
          send("process_#{name}", :process_context)
        end
      end

      endpoint :create, with: :create_endpoint
      endpoint :destroy, with: :destroy_endpoint
      endpoint :index, with: :index_endpoint
      endpoint :show, with: :show_endpoint
      endpoint :update, with: :update_endpoint

      process_index with: :process_pagination

      def create_endpoint(**options)
        if options[:object].errors.empty?
          render json: serialize(options[:object], **options), status: :created
        else
          render json: options[:object].errors, status: :unprocessable_entity
        end
      end

      def destroy_endpoint(**options)
        if options[:object].errors.empty?
          render json: {}, status: :no_content
        else
          render json: options[:object].errors, status: :unprocessable_entity
        end
      end

      def index_endpoint(**options)
        render json: serialize(options[:object], **options), status: :ok
      end

      def show_endpoint(**options)
        render json: serialize(options[:object], **options), status: :ok
      end

      def update_endpoint(**options)
        if options[:object].errors.empty?
          render json: serialize(options[:object], **options), status: :ok
        else
          render json: options[:object].errors, status: :unprocessable_entity
        end
      end
    end
  end
end
