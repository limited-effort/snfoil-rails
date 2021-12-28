RSpec.shared_context "penguin", shared_context: :metadata do
  let(:attributes) do
    {
      name: 'Emperor Penguin',
      kingdom: 'Animalia',
      phylum: 'Chordata',
      family: 'Spheniscidae',
      genus: 'Aptenodytes'
    }
  end

  let(:penguin) { Animal.create! **attributes }
end