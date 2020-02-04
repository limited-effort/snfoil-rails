# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::Controller::Concerns::ChangeControllerConcern do
  let(:including_class) { Class.new ChangeControllerConcernClass }
  let(:including_instance) { including_class.new }

  describe '#render_change' do
    let(:model) { double }
    let(:errors) { [] }

    before do
      allow(model).to receive(:errors).and_return(errors)
      allow(including_instance).to receive(:render).and_call_original
      including_instance.render_change(model)
    end

    it 'checks the model for errors' do
      expect(model).to have_received(:errors)
    end

    context 'when the model has no errors' do
      it 'renders the model' do
        expect(including_instance).to have_received(:render).with(model)
      end
    end

    context 'when the model has errors' do
      let(:errors) { [true] }

      it 'renders the model errors and status' do
        expect(including_instance).to have_received(:render).with(errors, hash_including(status: :unprocessable_entity))
      end
    end
  end
end

class ChangeControllerConcernClass
  include SnFoil::Rails::Controller::Concerns::ChangeControllerConcern

  def render(*_, **_); end
end
