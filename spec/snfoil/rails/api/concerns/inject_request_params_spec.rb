# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::InjectRequestParams, type: :concern do
  subject(:including_class) { InjectRequestParamsStub.clone }

  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
    allow(including_class_instance).to receive(:params).and_return(
      ActionController::Parameters.new({ 'action': 'params' }) # rubocop:disable Lint/SymbolConversion
    )
  end

  describe '#inject_request_params' do
    let(:options) { {} }

    it 'calls the params method of the controller' do
      including_class_instance.inject_request_params(**options)
      expect(including_class_instance).to have_received(:params).twice
    end

    it 'injects a standard hash as params' do
      ret = including_class_instance.inject_request_params(**options)[:params]
      expect(ret).to eq({ action: 'params' })
    end

    it 'injects a standard hash as request_params' do
      ret = including_class_instance.inject_request_params(**options)[:request_params]
      expect(ret).to eq({ action: 'params' })
    end

    context 'when params is already in the options' do
      let(:options) { { params: { test: 'test' } } }

      it 'does nothing' do
        ret = including_class_instance.inject_request_params(**options)[:params]
        expect(ret).to eq({ test: 'test' })
      end
    end
  end
end

class InjectRequestParamsStub
  def params; end
end
