# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::Controller::Concerns::CreateControllerConcern do
  let(:including_class) { Class.new CreateControllerConcernClass }
  let(:including_instance) { including_class.new }
  let(:context) { double }
  let(:context_instance) { double }

  before do
    including_class.context context
    allow(context).to receive(:new).and_return(context_instance)
    allow(context_instance).to receive(:create).and_return(OpenStruct.new(errors: []))
  end

  it 'includes SetupControllerConcern' do
    expect(including_class.ancestors).to include(SnFoil::Rails::Controller::Concerns::SetupControllerConcern)
  end

  it 'includes ChangeControllerConcern' do
    expect(including_class.ancestors).to include(SnFoil::Rails::Controller::Concerns::ChangeControllerConcern)
  end

  describe '#create' do
    before do
      allow(including_instance).to receive(:setup_create).and_call_original
      allow(including_instance).to receive(:process_create).and_call_original
      allow(including_instance).to receive(:render_create).and_call_original
      including_instance.create
    end

    it 'calls setup_create with options hash' do
      expect(including_instance).to have_received(:setup_create).with(kind_of(Hash))
    end

    it 'calls process_create with options hash' do
      expect(including_instance).to have_received(:process_create).with(kind_of(Hash))
    end

    it 'calls render_create with model and options hash' do
      expect(including_instance).to have_received(:render_create).with(kind_of(OpenStruct), kind_of(Hash))
    end
  end

  describe '#setup_create' do
    before do
      allow(including_instance).to receive(:setup_options)
      including_instance.setup_create
    end

    it 'calls setup_options' do
      expect(including_instance).to have_received(:setup_options)
    end
  end

  describe '#process_create' do
    before do
      allow(including_instance).to receive(:current_context).and_call_original
      including_instance.process_create
    end

    it 'calls current context with the options hash' do
      expect(including_instance).to have_received(:current_context).with(kind_of(Hash))
    end

    it 'instantiates a context' do
      expect(context).to have_received(:new)
    end

    it 'calls create on the context object with the options hash' do
      expect(context_instance).to have_received(:create).with(kind_of(Hash))
    end
  end

  describe '#render_create' do
    before do
      allow(including_instance).to receive(:render_change)
      including_instance.render_create(OpenStruct.new)
    end

    it 'calls render_change with model and options hash' do
      expect(including_instance).to have_received(:render_change).with(kind_of(OpenStruct), kind_of(Hash))
    end
  end
end

class CreateControllerConcernClass
  include SnFoil::Rails::Controller::Concerns::CreateControllerConcern
  def render(*_, **_); end

  def params
    ActionController::Parameters.new({})
  end
end
