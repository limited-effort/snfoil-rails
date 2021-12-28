# frozen_string_literal: true

module Api
  class CreateController < ActionController::API
    include SnFoil::Rails::API::Create

    context AnimalContext
    deserializer AnimalDeserializer
    serializer(AnimalSerializer) do |object, serializer, **_|
      serializer.render(object)
    end
  end
end
