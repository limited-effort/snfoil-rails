# frozen_string_literal: true

module Api
  class AnimalController < SnFoil::Rails::ApiController
    context AnimalContext
    deserializer AnimalDeserializer
    serializer(AnimalSerializer) do |object, serializer, **_|
      serializer.render(object)
    end
  end
end
