# frozen_string_literal: true

require 'active_support/concern'
require_relative '../../controller'

module SnFoil
  module Rails
    module API
      module Update
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::API::Edit

          endpoint :update, with: :update_endpoint
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
end
