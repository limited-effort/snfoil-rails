# frozen_string_literal: true

require 'active_support/concern'
require_relative '../../controller'

module SnFoil
  module Rails
    module API
      module Destroy
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          endpoint :destroy, with: :destroy_endpoint
        end

        def destroy_endpoint(**options)
          if options[:object].errors.empty?
            render json: {}, status: :no_content
          else
            render json: options[:object].errors, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
