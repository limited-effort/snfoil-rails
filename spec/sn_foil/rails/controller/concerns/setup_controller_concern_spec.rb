# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::Controller::Concerns::SetupControllerConcern do
  let(:including_class) { Class.new SetupControllerConcernClass }

  describe '#self.context' do
    let(:context) { double }

    before { including_class.context(context) }

    it 'sets i_context' do
      expect(including_class.i_context).to eq context
    end

    it 'manipulates #context' do
      expect(including_class.new.context).to eq context
    end
  end

  describe '#context' do
    let(:context) { double }

    before { including_class.context(context) }

    it 'uses the class var i_context' do
      expect(including_class.new.context).to eq context
    end

    context 'with options[:context] => value' do
      let(:options_context) { double }

      it 'uses the option' do
        expect(including_class.new.context(context: options_context)).to eq options_context
      end
    end
  end

  describe 'current_context' do
    let(:context) { double }
    let(:including_class_instance) { including_class.new }

    before do
      including_class.context context
      allow(context).to receive(:new)
    end

    context 'when there is no current user' do
      it 'instantiates the context without a user' do
        including_class_instance.current_context
        expect(context).to have_received(:new).with(nil)
      end
    end

    context 'when there is a current user' do
      let(:user) { double }

      before do
        allow(including_class_instance).to receive(:current_user).and_return(user)
      end

      it 'instantiates the context without a user' do
        including_class_instance.current_context
        expect(context).to have_received(:new).with(user)
      end
    end
  end

  describe '#setup_options' do
    let(:including_class_instance) { including_class.new }
    let(:options) { {} }
    let(:params) { ActionController::Parameters.new(id: 1, data: 2) }
    let(:output) { including_class_instance.setup_options(options) }

    before do
      allow(including_class_instance).to receive(:params).and_return(params)
    end

    it 'sets options[:params]' do
      expect(output[:params][:data]).to eq 2
    end

    it 'sets options[:controller_params]' do
      expect(output[:controller_params][:data]).to eq 2
    end

    it 'sets id from params' do
      expect(output[:id]).to eq 1
    end

    it 'doesn\'t set options[:include] params' do
      expect(output.key?(:include)).to be false
    end

    it 'doesn\'t set options[:controller_action] params' do
      expect(output.key?(:controller_action)).to be false
    end

    context 'with options[:params] => value' do
      let(:options) { { params: { data: 5 } } }

      it 'sets options[:params] from options[:params]' do
        expect(output[:params][:data]).to eq 5
      end
    end

    context 'with options[:id] => value' do
      let(:options) { { id: 3 } }

      it 'sets options[:id] from options[:id]' do
        expect(output[:id]).to eq 3
      end
    end

    context 'with variable id defined on the object' do
      before do
        allow(including_class_instance).to receive(:id).and_return(4)
      end

      it 'sets options[:id] from variable' do
        expect(output[:id]).to eq 4
      end
    end

    context 'with variable id defined on the object and an id in the params' do
      before do
        allow(including_class_instance).to receive(:id).and_return(4)
      end

      it 'sets options[:id] from variable' do
        expect(output[:params][:id]).to eq 1
        expect(output[:id]).to eq 4
      end
    end

    context 'with variable id defined on the object and an id in the params and options[:id] => value' do
      let(:options) { { id: 3 } }

      before do
        allow(including_class_instance).to receive(:id).and_return(4)
      end

      it 'sets options[:id] from options[:id]' do
        expect(output[:params][:id]).to eq 1
        expect(including_class_instance.id).to eq 4
        expect(output[:id]).to eq 3
      end
    end

    context 'with params[:include] => value' do
      let(:params) do
        ActionController::Parameters.new(
          id: 1,
          data: 2,
          include: 'dollar,dollar.dollaBills'
        )
      end

      it 'parses the include' do
        expect(output[:include]).to include :dollar, :'dollar.dolla_bills'
      end
    end

    context 'with options[:include] => value' do
      let(:options) { { include: %i[pepper roni] } }

      it 'uses the options[:include]' do
        expect(output[:include]).to include :pepper, :roni
      end
    end

    context 'with params[:action] => value' do
      let(:params) do
        ActionController::Parameters.new(
          id: 1,
          data: 2,
          action: :create
        )
      end

      it 'assigns that value to options[:controller_action]' do
        expect(output[:controller_action]).to eq :create
      end
    end

    context 'with options[:controller_action] => value' do
      let(:options) { { controller_action: :update } }

      it 'uses the options[:controller_action]' do
        expect(output[:controller_action]).to eq :update
      end
    end
  end
end

class SetupControllerConcernClass
  include SnFoil::Rails::Controller::Concerns::SetupControllerConcern
  def current_user; end

  def params; end

  def id; end
end
