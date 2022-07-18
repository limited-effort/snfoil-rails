# frozen_string_literal: true

RSpec.shared_context 'with animal', shared_context: :metadata do
  let(:attributes) do
    {
      name: 'Emperor Penguin',
      kingdom: 'Animalia',
      phylum: 'Chordata',
      family: 'Spheniscidae',
      genus: 'Aptenodytes'
    }
  end

  let(:penguin) { Animal.create!(**attributes) }
end
