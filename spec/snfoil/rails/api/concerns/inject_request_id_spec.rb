# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::InjectRequestId, type: :concern do
  subject(:including_class) { InjectRequestIdStub.clone }

  let(:entity) { double }
  let(:uuid) { SecureRandom.uuid }
  let(:request) { double }
  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
    allow(request).to receive(:request_id).and_return(uuid)
    allow(including_class_instance).to receive(:request).and_return(request)
  end

  describe '#inject_request_id' do
    it 'deserializes with the params in the options' do
      options = including_class_instance.inject_request_id(**{})
      expect(options[:request_id]).to eq(uuid)
    end
  end
end

class InjectRequestIdStub
  def request; end
end
