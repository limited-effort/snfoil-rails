# frozen_string_literal: true

require 'active_support/concern'
require 'snfoil/controller'

module SnFoil
  module Rails
    module Controller
      extend ActiveSupport::Concern

      included do
        include SnFoil::Controller

        module_eval do
          def initialize(*args, **keyword_args, &block)
            super(*args, **keyword_args, &block)

            @entity = keyword_args[:entity]
          end
        end
      end
    end
  end
end
