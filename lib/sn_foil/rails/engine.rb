# frozen_string_literal: true

module SnFoil
  module Rails
    class Engine < ::Rails::Engine
      require 'sn_foil'
      require_relative '../searcher'
      require_relative '../jsonapi_serializer'
      require_relative '../jsonapi_deserializer'

      require_relative '../configuration/lazy_jsonapi_serializer'
    end
  end
end
