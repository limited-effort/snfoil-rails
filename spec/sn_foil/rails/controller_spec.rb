require 

RSpec.describe SnFoil::Rails::Controller do
  subject(:including_class) { Class.new ControllerSpecCass }

  describe '#self.context' do
    let(:context) { double }

    before { including_class.context(context) }

    it 'sets snfoil_context' do
      expect(including_class.snfoil_context).to eq context
    end

    it 'manipulates #context' do
      expect(including_class.new.context).to eq context
    end
  end

  describe '#self.serializer' do
    let(:serializer) { double }

    before { including_class.serializer(serializer) }

    it 'sets snfoil_serializer' do
      expect(including_class.snfoil_serializer).to eq serializer
    end

    it 'manipulates #serializer' do
      expect(including_class.new.serializer).to eq serializer
    end
  end

  describe '#self.deserializer' do
    let(:deserializer) { double }

    before { including_class.deserializer(deserializer) }

    it 'sets snfoil_deserializer' do
      expect(including_class.snfoil_deserializer).to eq deserializer
    end

    it 'manipulates #deserializer' do
      expect(including_class.new.deserializer).to eq deserializer
    end
  end
end

class ControllerSpecCass
  include SnFoil::Rails::Controller
end
