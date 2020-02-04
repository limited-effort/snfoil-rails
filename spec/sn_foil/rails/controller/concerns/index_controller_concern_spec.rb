# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::Controller::Concerns::IndexControllerConcern do
  let(:including_class) { Class.new IndexControllerConcernClass }
  let(:including_instance) { including_class.new }
  let(:context) { double }
  let(:context_instance) { double }
  let(:context_return) { results }
  let(:results) { double }

  before do
    including_class.context context
    allow(context).to receive(:new).and_return(context_instance)
    allow(context_instance).to receive(:index).and_return(context_return)
    allow(results).to receive(:page).and_return(results)
    allow(results).to receive(:per).and_return(results)
    allow(results).to receive(:total_pages).and_return(2)
    allow(results).to receive(:total_count).and_return(20)
  end

  it 'includes SetupControllerConcern' do
    expect(including_class.ancestors).to include(SnFoil::Rails::Controller::Concerns::SetupControllerConcern)
  end

  describe '#index' do
    before do
      allow(including_instance).to receive(:setup_index).and_call_original
      allow(including_instance).to receive(:process_index).and_call_original
      allow(including_instance).to receive(:render_index).and_call_original
      including_instance.index
    end

    it 'calls setup_index with options hash' do
      expect(including_instance).to have_received(:setup_index).with(kind_of(Hash))
    end

    it 'calls process_index with options hash' do
      expect(including_instance).to have_received(:process_index).with(kind_of(Hash))
    end

    it 'calls render_index with results and options hash' do
      expect(including_instance).to have_received(:render_index).with(results, kind_of(Hash))
    end
  end

  describe '#setup_index' do
    before do
      allow(including_instance).to receive(:setup_options)
      including_instance.setup_index
    end

    it 'calls render_index' do
      expect(including_instance).to have_received(:setup_options)
    end
  end

  describe '#process_index' do
    before do
      allow(including_instance).to receive(:current_context).and_call_original
      including_instance.process_index
    end

    it 'calls current context with the options hash' do
      expect(including_instance).to have_received(:current_context).with(kind_of(Hash))
    end

    it 'instantiates a context' do
      expect(context).to have_received(:new)
    end

    it 'calls index on the context object with the options hash' do
      expect(context_instance).to have_received(:index).with(kind_of(Hash))
    end
  end

  describe '#render_index' do
    context 'when the results respond to kaminari' do
      before do
        allow(results).to receive(:page).and_return(results)
        allow(results).to receive(:per).and_return(results)
      end

      it 'paginates the results' do
        including_instance.render_index(results)
        expect(results).to have_received(:page)
        expect(results).to have_received(:per)
      end

      it 'renders the results with meta' do
        allow(including_instance).to receive(:render)
        including_instance.render_index(results)
        expect(including_instance).to have_received(:render).with(results, hash_including(:meta))
      end
    end

    context 'when the results do not respond to kaminari' do
      let(:other_results) { double }
      let(:context_return) { other_results }

      it 'renders the results' do
        allow(including_instance).to receive(:render)
        including_instance.render_index(results)
        expect(including_instance).to have_received(:render).with(results, hash_including(:meta))
      end
    end
  end

  describe '#page' do
    it 'defaults to 1' do
      expect(including_instance.page).to eq 1
    end

    context 'with options[:params][:page] => value' do
      it 'uses the option value' do
        expect(including_instance.page({ params: { page: 7 } })).to eq 7
      end
    end
  end

  describe '#per_page' do
    it 'defaults to 10' do
      expect(including_instance.per_page).to eq 10
    end

    context 'with options[:params][:per_page] => value' do
      it 'uses the option value' do
        expect(including_instance.per_page({ params: { per_page: 50 } })).to eq 50
      end

      context 'when the value is zero' do
        it 'returns 1000' do
          expect(including_instance.per_page({ params: { per_page: 0 } })).to eq 1000
        end
      end

      context 'when the value is greater than 1000' do
        it 'returns 1000' do
          expect(including_instance.per_page({ params: { per_page: 9999 } })).to eq 1000
        end
      end
    end
  end

  describe '#meta' do
    let(:meta) { including_instance.meta(context_return) }

    it 'includes the page' do
      expect(meta[:page]).to eq 1
    end

    it 'includes the per_page' do
      expect(meta[:per]).to eq 10
    end

    context 'when the results respond to kaminari' do
      it 'includes the total pages' do
        expect(meta[:pages]).to eq 2
      end

      it 'includes the total count' do
        expect(meta[:total]).to eq 20
      end
    end

    context 'when the results do not respond to kaminari' do
      let(:other_results) { double }
      let(:context_return) { other_results }

      it 'nils the total pages' do
        expect(meta[:pages]).to eq nil
      end

      it 'nils the total count' do
        expect(meta[:total]).to eq nil
      end
    end
  end
end

class IndexControllerConcernClass
  include SnFoil::Rails::Controller::Concerns::IndexControllerConcern
  def render(*_, **_); end

  def params
    ActionController::Parameters.new({})
  end
end
