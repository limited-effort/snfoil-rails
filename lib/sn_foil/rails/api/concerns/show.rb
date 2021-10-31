# frozen_string_literal: true

require 'active_support/concern'
require_relative '../../controller'

module SnFoil
  module Rails
    module API
      module Show
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller

          endpoint :show, with: :show_endpoint
        end

        def show_endpoint(**options)
          render json: serialize(options[:object], **options), status: :ok
        end
      end
    end
  end
end
