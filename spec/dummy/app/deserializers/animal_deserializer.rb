# frozen_string_literal: true

class AnimalDeserializer
  include SnFoil::Deserializer::JSON

  attributes :name, namespace: [:animal]
end
