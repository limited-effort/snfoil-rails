# frozen_string_literal: true

module SnFoil
  module Rails
    if Object.const_defined?(:Rails)
      require 'snfoil/rails/engine'
    else
      require 'snfoil'
      require_relative 'controller'
      require_relative 'jsonapi_serializer'
      require_relative 'jsonapi_deserializer'
      require_relative 'searcher'
    end
  end
end
