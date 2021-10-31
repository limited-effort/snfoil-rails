# frozen_string_literal: true

require 'active_support/concern'
require_relative '../concerns/process_pagination'
require_relative '../../controller'

module SnFoil
  module Rails
    module API
      module Index
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller
          include SnFoil::Rails::ProcessPagination

          endpoint :index, with: :index_endpoint

          process_index with: :process_pagination
        end

        def index_endpoint(**options)
          render json: serialize(options[:object], **options)
        end
      end
    end
  end
end
