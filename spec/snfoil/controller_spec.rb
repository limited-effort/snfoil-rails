# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SnFoil::Controller do
  subject(:including_class) { Class.new ControllerSpecClass }

  let(:canary) { Canary.new }

  describe '#self.context' do
    let(:context) { double }

    before { including_class.context(context) }

    it 'sets snfoil_context' do
      expect(including_class.snfoil_context).to eq context
    end
  end

  describe '#self.serializer' do
    let(:serializer) { double }

    before { including_class.serializer(serializer) }

    it 'sets snfoil_serializer' do
      expect(including_class.snfoil_serializer).to eq serializer
    end
  end

  describe '#self.deserializer' do
    let(:deserializer) { double }

    before { including_class.deserializer(deserializer) }

    it 'sets snfoil_deserializer' do
      expect(including_class.snfoil_deserializer).to eq deserializer
    end
  end

  describe '#self.endpoint' do
    it 'creates setup_#{name} hooks' do # rubocop:disable Lint/InterpolationCheck
      including_class.endpoint(:demo, with: :render_demo)
      expect(including_class.respond_to?(:setup_demo)).to be true
    end

    it 'creates process_#{name} hooks' do # rubocop:disable Lint/InterpolationCheck
      including_class.endpoint(:demo, with: :render_demo)
      expect(including_class.respond_to?(:process_demo)).to be true
    end

    it 'defines an instance method' do
      including_class.endpoint(:demo, with: :render_demo)
      expect(including_class.new.respond_to?(:demo)).to be true
    end

    context 'when called with a method' do
      it 'calls the method on the instance call' do
        including_class.endpoint(:demo, with: :render_demo)
        including_class.define_method(:render_demo) { |**options| options[:canary].sing('Method Call') }
        including_class.new.demo(canary: canary)

        expect(canary.sung?('Method Call')).to be true
      end
    end

    context 'when called with a block' do
      it 'calls the block on the instance call' do
        including_class.endpoint(:demo) { |**options| options[:canary].sing('Block Call') }
        including_class.new.demo(canary: canary)

        expect(canary.sung?('Block Call')).to be true
      end
    end

    describe '#entity' do
      context 'when current_entity is defined' do
        before { including_class.define_method(:current_entity) { 'entity' } }

        it 'uses it' do
          expect(including_class.new.entity).to eq 'entity'
        end
      end

      context 'when current_user is defined' do
        before { including_class.define_method(:current_user) { 'user' } }

        it 'uses it' do
          expect(including_class.new.entity).to eq 'user'
        end
      end
    end
  end
end

class ControllerSpecClass
  include SnFoil::Controller
end
