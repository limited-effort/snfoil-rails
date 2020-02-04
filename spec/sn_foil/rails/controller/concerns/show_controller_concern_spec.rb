# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::Controller::Concerns::ShowControllerConcern do
  let(:including_class) { Class.new ShowControllerConcernClass }
  let(:including_instance) { including_class.new }
  let(:context) { double }
  let(:context_instance) { double }

  before do
    including_class.context context
    allow(context).to receive(:new).and_return(context_instance)
    allow(context_instance).to receive(:show).and_return(OpenStruct.new(errors: []))
  end

  it 'includes SetupControllerConcern' do
    expect(including_class.ancestors).to include(SnFoil::Rails::Controller::Concerns::SetupControllerConcern)
  end

  describe '#show' do
    before do
      allow(including_instance).to receive(:setup_show).and_call_original
      allow(including_instance).to receive(:process_show).and_call_original
      allow(including_instance).to receive(:render_show).and_call_original
      including_instance.show
    end

    it 'calls setup_show with options hash' do
      expect(including_instance).to have_received(:setup_show).with(kind_of(Hash))
    end

    it 'calls process_show with options hash' do
      expect(including_instance).to have_received(:process_show).with(kind_of(Hash))
    end

    it 'calls render_show with model and options hash' do
      expect(including_instance).to have_received(:render_show).with(kind_of(OpenStruct), kind_of(Hash))
    end
  end

  describe '#setup_show' do
    before do
      allow(including_instance).to receive(:setup_options)
      including_instance.setup_show
    end

    it 'calls render_show' do
      expect(including_instance).to have_received(:setup_options)
    end
  end

  describe '#process_show' do
    before do
      allow(including_instance).to receive(:current_context).and_call_original
      including_instance.process_show
    end

    it 'calls current context with the options hash' do
      expect(including_instance).to have_received(:current_context).with(kind_of(Hash))
    end

    it 'instantiates a context' do
      expect(context).to have_received(:new)
    end

    it 'calls show on the context object with the options hash' do
      expect(context_instance).to have_received(:show).with(kind_of(Hash))
    end
  end

  describe '#render_show' do
    let(:model) { OpenStruct.new }

    before do
      allow(including_instance).to receive(:render).and_call_original
      including_instance.render_show(model)
    end

    it 'renders the model' do
      expect(including_instance).to have_received(:render).with(model)
    end
  end
end

class ShowControllerConcernClass
  include SnFoil::Rails::Controller::Concerns::ShowControllerConcern
  def render(*_, **_); end

  def params
    ActionController::Parameters.new({})
  end
end
