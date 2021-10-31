# frozen_string_literal: true

require 'active_support/concern'
require_relative 'edit'

module SnFoil
  module Rails
    module SSR
      module Update
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller
          include SnFoil::Rails::SSR::Edit

          endpoint :update, with: :update_endpoint
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
end
