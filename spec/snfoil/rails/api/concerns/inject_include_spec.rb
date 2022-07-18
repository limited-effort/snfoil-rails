# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::InjectInclude, type: :concern do
  subject(:including_class) { InjectIncludeStub.clone }

  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
  end

  describe '#inject_include' do
    context 'when include is already in the options' do
      let(:options) { { include: [:test] } }

      it 'does nothing' do
        array = including_class_instance.inject_include(**options)[:include]
        expect(array).to eq [:test]
      end
    end

    context 'with options[:params][:include] => value' do
      let(:options) { { params: { include: 'bacon,yum' } } }

      it 'injects the params include' do
        array = including_class_instance.inject_include(**options)[:include]
        expect(array).to eq %i[bacon yum]
      end

      it 'seperates include by comma' do
        array = including_class_instance.inject_include(**options)[:include]
        expect(array).to be_a Array
      end

      context 'when include is already in the options' do
        let(:options) { { include: [:test], params: { include: 'bacon,yum' } } }

        it 'does nothing' do
          array = including_class_instance.inject_include(**options)[:include]
          expect(array).to eq [:test]
        end
      end
    end

    context 'when there are no include in the options' do
      let(:options) { {} }

      it 'does nothing' do
        opts = including_class_instance.inject_include(**options)
        expect(opts.keys).not_to include :include
      end
    end
  end
end

class InjectIncludeStub # rubocop:disable Lint/EmptyClass
end
