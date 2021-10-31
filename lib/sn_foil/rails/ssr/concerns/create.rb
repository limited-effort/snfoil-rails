# frozen_string_literal: true

require 'active_support/concern'
require_relative 'new'

module SnFoil
  module Rails
    module SSR
      module Create
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller
          include SnFoil::Rails::SSR::New

          endpoint :create, with: :create_endpoint
        end

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
      end
    end
  end
end
