# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::InjectId, type: :concern do
  subject(:including_class) { InjectIdStub.clone }

  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
  end

  describe '#inject_id' do
    let(:options) { {} }

    context 'when id is already in the options' do
      let(:options) { { id: SecureRandom.uuid } }

      it 'returns the id already in the options' do
        expect(including_class_instance.inject_id(**options)[:id]).to eq options[:id]
      end
    end

    context 'when id is defined as a method' do
      let(:id) { SecureRandom.uuid }

      before do
        including_class.define_method(:id) { nil }
        allow(including_class_instance).to receive(:id).and_return(id)
      end

      it 'calls the #id method' do
        including_class_instance.inject_id(**options)
        expect(including_class_instance).to have_received(:id).once
      end

      it 'injects the #id return' do
        expect(including_class_instance.inject_id(**options)[:id]).to eq id
      end

      context 'when id is already in the options' do
        let(:options) { { id: SecureRandom.uuid } }

        it 'returns the id already in the options' do
          expect(including_class_instance.inject_id(**options)[:id]).to eq options[:id]
          expect(including_class_instance.inject_id(**options)[:id]).not_to eq id
        end
      end

      context 'with options params[:id] => value' do
        let(:options) { { params: { id: SecureRandom.uuid } } }

        it 'injects the #id return' do
          expect(including_class_instance.inject_id(**options)[:id]).to eq id
          expect(including_class_instance.inject_id(**options)[:id]).not_to eq options[:params][:id]
        end
      end
    end

    context 'with options params[:id] => value' do
      let(:options) { { params: { id: SecureRandom.uuid } } }

      it 'injects the params[:id]' do
        expect(including_class_instance.inject_id(**options)[:id]).to eq options[:params][:id]
      end

      context 'when id is already in the options' do
        let(:options) { { id: SecureRandom.uuid, params: { id: SecureRandom.uuid } } }

        it 'returns the id already in the options' do
          expect(including_class_instance.inject_id(**options)[:id]).to eq options[:id]
          expect(including_class_instance.inject_id(**options)[:id]).not_to eq options[:params][:id]
        end
      end
    end
  end
end

class InjectIdStub # rubocop:disable Lint/EmptyClass
end
