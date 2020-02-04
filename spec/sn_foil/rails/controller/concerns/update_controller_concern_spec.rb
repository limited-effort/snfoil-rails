# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::Controller::Concerns::UpdateControllerConcern do
  let(:including_class) { Class.new UpdateControllerConcernClass }
  let(:including_instance) { including_class.new }
  let(:context) { double }
  let(:context_instance) { double }

  before do
    including_class.context context
    allow(context).to receive(:new).and_return(context_instance)
    allow(context_instance).to receive(:update).and_return(OpenStruct.new(errors: []))
  end

  it 'includes SetupControllerConcern' do
    expect(including_class.ancestors).to include(SnFoil::Rails::Controller::Concerns::SetupControllerConcern)
  end

  it 'includes ChangeControllerConcern' do
    expect(including_class.ancestors).to include(SnFoil::Rails::Controller::Concerns::ChangeControllerConcern)
  end

  describe '#update' do
    before do
      allow(including_instance).to receive(:setup_update).and_call_original
      allow(including_instance).to receive(:process_update).and_call_original
      allow(including_instance).to receive(:render_update).and_call_original
      including_instance.update
    end

    it 'calls setup_update with options hash' do
      expect(including_instance).to have_received(:setup_update).with(kind_of(Hash))
    end

    it 'calls process_update with options hash' do
      expect(including_instance).to have_received(:process_update).with(kind_of(Hash))
    end

    it 'calls render_update with model and options hash' do
      expect(including_instance).to have_received(:render_update).with(kind_of(OpenStruct), kind_of(Hash))
    end
  end

  describe '#setup_update' do
    before do
      allow(including_instance).to receive(:setup_options)
      including_instance.setup_update
    end

    it 'calls setup_options' do
      expect(including_instance).to have_received(:setup_options)
    end
  end

  describe '#process_update' do
    before do
      allow(including_instance).to receive(:current_context).and_call_original
      including_instance.process_update
    end

    it 'calls current context with the options hash' do
      expect(including_instance).to have_received(:current_context).with(kind_of(Hash))
    end

    it 'instantiates a context' do
      expect(context).to have_received(:new)
    end

    it 'calls update on the context object with the options hash' do
      expect(context_instance).to have_received(:update).with(kind_of(Hash))
    end
  end

  describe '#render_update' do
    before do
      allow(including_instance).to receive(:render_change)
      including_instance.render_update(OpenStruct.new)
    end

    it 'calls render_change with model and options hash' do
      expect(including_instance).to have_received(:render_change).with(kind_of(OpenStruct), kind_of(Hash))
    end
  end
end

class UpdateControllerConcernClass
  include SnFoil::Rails::Controller::Concerns::UpdateControllerConcern
  def render(*_, **_); end

  def params
    ActionController::Parameters.new({})
  end
end
