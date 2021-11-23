# frozen_string_literal: true

require_relative 'controller'

module SnFoil
  module Rails
    class Controller < SnFoil::Rails::APIController
      endpoint :edit, with: :edit_endpoint
      endpoint :new, with: :new_endpoint

      def create_endpoint(**options)
        @object = options[:object]

        respond_to do |format|
          if @object.errors
            format.html  { render action: 'new' }
            format.json  { render json: @object.errors, status: :unprocessable_entity }
          else
            format.html  { redirect_to(@object, notice: 'Successfully Created') }
            format.json  { render json: @object, status: :created, location: @object }
          end
        end
      end

      def destroy_endpoint(**options)
        @object = options[:object]

        respond_to do |format|
          if @object.errors
            format.html  { render action: 'show' }
            format.json  { render json: @object.errors, status: :unprocessable_entity }
          else
            format.html  { redirect_to(action: :index, notice: 'Successfully Destroted') }
            format.json  { render status: :no_content, location: :index }
          end
        end
      end

      def edit_endpoint(**options)
        @object = options[:object]

        render options[:controller_action]
      end

      def index_endpoint(**options)
        @object = options[:object]

        respond_to do |format|
          format.html { render options[:controller_action] }
          format.json { render json: @object, status: :ok }
        end
      end

      def new_endpoint(**options)
        @object = options[:object]

        render options[:controller_action]
      end

      def show_endpoint(**options)
        @object = options[:object]

        respond_to do |format|
          format.html { render options[:controller_action] }
          format.json { render json: @object, status: :ok }
        end
      end

      def update_endpoint(**options)
        @object = options[:object]

        respond_to do |format|
          if @object.errors
            format.html  { render action: 'edit' }
            format.json  { render json: @object.errors, status: :unprocessable_entity }
          else
            format.html  { redirect_to(@object, notice: 'Successfully Updated') }
            format.json  { render json: @object, status: :ok, location: @object }
          end
        end
      end
    end
  end
end
