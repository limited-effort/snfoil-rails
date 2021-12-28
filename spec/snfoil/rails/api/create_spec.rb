RSpec.describe SnFoil::Rails::API::Create, type: :controller do
  before { @controller = Api::CreateController.new }
  let(:animal) do
    Animal.create!
      name: 'Emperor Penguin',
      kingdom: 'Animalia',
      phylum: 'Chordata',
      family: 'Spheniscidae',
      genus: 'Aptenodytes'
  end

  it 'sets the request params' do
  end

  it 'deserializes params' do
  end

  it 'parses included params' do
  end

  it 'calls the context\'s create action' do
  end

  it 'serializes the response' do
  end
end