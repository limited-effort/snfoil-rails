# frozen_string_literal: true

module SnFoil
  module Rails
    class Engine < ::Rails::Engine
      require 'snfoil'
      require_relative '../controller'
      require_relative '../jsonapi_deserializer'
      require_relative '../jsonapi_serializer'
      require_relative '../searcher'
      require_relative 'basic_controller'
    end
  end
end
