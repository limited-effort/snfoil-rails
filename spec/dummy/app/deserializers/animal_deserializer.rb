# frozen_string_literal: true

require 'snfoil/deserializer/json'

class AnimalDeserializer
  include SnFoil::Deserializer::JSON

  attributes :name, namespace: [:animal]
end
