# frozen_string_literal: true

module Api
  class AnimalsController < SnFoil::Rails::APIController
    context AnimalContext
    deserializer AnimalDeserializer
    serializer(AnimalSerializer) do |object, serializer, **options|
      serializer.render(object,
                        root: self.class.snfoil_context.snfoil_model.name.underscore,
                        meta: options[:meta])
    end
  end
end
