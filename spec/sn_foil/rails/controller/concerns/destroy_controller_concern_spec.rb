# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::Controller::Concerns::DestroyControllerConcern do
  let(:including_class) { Class.new DestroyControllerConcernClass }
  let(:including_instance) { including_class.new }
  let(:context) { double }
  let(:context_instance) { double }

  before do
    including_class.context context
    allow(context).to receive(:new).and_return(context_instance)
    allow(context_instance).to receive(:destroy).and_return(OpenStruct.new(errors: []))
  end

  it 'includes SetupControllerConcern' do
    expect(including_class.ancestors).to include(SnFoil::Rails::Controller::Concerns::SetupControllerConcern)
  end

  describe '#destroy' do
    before do
      allow(including_instance).to receive(:setup_destroy).and_call_original
      allow(including_instance).to receive(:process_destroy).and_call_original
      allow(including_instance).to receive(:render_destroy).and_call_original
      including_instance.destroy
    end

    it 'calls setup_destroy with options hash' do
      expect(including_instance).to have_received(:setup_destroy).with(kind_of(Hash))
    end

    it 'calls process_destroy with options hash' do
      expect(including_instance).to have_received(:process_destroy).with(kind_of(Hash))
    end

    it 'calls render_destroy with model and options hash' do
      expect(including_instance).to have_received(:render_destroy).with(kind_of(OpenStruct), kind_of(Hash))
    end
  end

  describe '#setup_destroy' do
    before do
      allow(including_instance).to receive(:setup_options)
      including_instance.setup_destroy
    end

    it 'calls render_destroy' do
      expect(including_instance).to have_received(:setup_options)
    end
  end

  describe '#process_destroy' do
    before do
      allow(including_instance).to receive(:current_context).and_call_original
      including_instance.process_destroy
    end

    it 'calls current context with the options hash' do
      expect(including_instance).to have_received(:current_context).with(kind_of(Hash))
    end

    it 'instantiates a context' do
      expect(context).to have_received(:new)
    end

    it 'calls destroy on the context object with the options hash' do
      expect(context_instance).to have_received(:destroy).with(kind_of(Hash))
    end
  end

  describe '#render_destroy' do
    let(:model) { double }
    let(:errors) { [] }

    before do
      allow(model).to receive(:errors).and_return(errors)
      allow(including_instance).to receive(:render).and_call_original
      including_instance.render_destroy(model)
    end

    it 'checks the model for errors' do
      expect(model).to have_received(:errors)
    end

    context 'when the model has no errors' do
      it 'renders the model' do
        expect(including_instance).to have_received(:render).with(nil)
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

class DestroyControllerConcernClass
  include SnFoil::Rails::Controller::Concerns::DestroyControllerConcern
  def render(*_, **_); end

  def params
    ActionController::Parameters.new({})
  end
end
