# frozen_string_literal: true

require 'active_support/concern'
require_relative '../../controller'

module SnFoil
  module Rails
    module API
      module Create
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          endpoint :create, with: :create_endpoint
        end

        def create_endpoint(**options)
          if options[:object].errors.empty?
            render json: serialize(options[:object], **options), status: :created
          else
            render json: options[:object].errors, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
