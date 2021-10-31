# frozen_string_literal: true

require 'active_support/concern'
require_relative '../concerns/process_pagination'

module SnFoil
  module Rails
    module SSR
      module Index
        extend ActiveSupport::Concern

        included do
          include SnFoil::Rails::Controller
          include SnFoil::Rails::ProcessPagination

          endpoint :index, with: :index_endpoint

          process_index with: :process_pagination
        end

        def index_endpoint(**options)
          @object = options[:object]

          render options[:controller_action]
        end
      end
    end
  end
end
