# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::InjectDeserialized, type: :concern do
  subject(:including_class) { InjectDeserializedStub.clone }

  let(:entity) { double }
  let(:params) { SecureRandom.uuid }
  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
    allow(including_class_instance).to receive(:deserialize)
  end

  describe '#inject_deserialized' do
    let(:options) { { params: params } }

    it 'deserializes with the params in the options' do
      including_class_instance.inject_deserialized(**options)
      expect(including_class_instance).to have_received(:deserialize).with(params, any_args)
    end
  end
end

class InjectDeserializedStub
  def deserialize(_, _); end
end
