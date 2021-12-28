# frozen_string_literal: true

module SnFoil
  module Rails
    class Engine < ::Rails::Engine
      require 'snfoil'
      require_relative 'searcher'

      require_relative 'api/create'
      require_relative 'api/destroy'
      require_relative 'api/index'
      require_relative 'api/show'
      require_relative 'api/update'
      require_relative 'api_controller'
    end
  end
end
