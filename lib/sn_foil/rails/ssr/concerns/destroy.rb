# frozen_string_literal: true

require 'active_support/concern'
require_relative '../concerns/process_pagination'
require_relative 'edit'

module SnFoil
  module Rails
    module SSR
      module Update
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller
          include SnFoil::Rails::SSR::Index

          endpoint :update, with: :update_endpoint
        end

        def update_endpoint(**options)
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
      end
    end
  end
end
