# frozen_string_literal: true

module Api
  class UpdateController < ActionController::API
    include SnFoil::Rails::API::Update

    context AnimalContext
    deserializer AnimalDeserializer
    serializer(AnimalSerializer) do |object, serializer, **_|
      serializer.render(object)
    end
  end
end
