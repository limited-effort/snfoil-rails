# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Searcher do
  subject(:searcher) { Class.new TestSearcherClass }

  let(:instance) { searcher.new }
  let(:params) { {} }
  let(:query) { instance.search(params).to_sql }
  let(:canary) { Canary.new }

  before do
    searcher.model(Animal)
  end

  describe '#self.setup' do
    let(:params) { { canary: canary } }

    before do
      searcher.filter do |scope, params|
        params[:canary].sing(:filter_block)
        scope.where(family: 'filter')
      end

      searcher.setup do |scope, params|
        params[:canary].sing(:setup_block)
        scope.where(tribe: 'setup_block')
      end
    end

    context 'with a block' do
      it 'calls the setup block' do
        expect(query).to match(/"animals"."tribe" = 'setup_block'/)
      end

      it 'calls setup before filter' do
        query
        expect(canary.sing[0][:data]).to eq :setup_block
        expect(canary.sing[1][:data]).to eq :filter_block
      end
    end

    context 'with a method' do
      before do
        searcher.define_method(:setup_method) do |scope, params|
          params[:canary].sing(:setup_method)
          scope.where(tribe: 'setup_method')
        end

        searcher.setup(:setup_method)
      end

      it 'calls the setup method' do
        expect(query).to match(/"animals"."tribe" = 'setup_method'/)
      end

      it 'calls setup before filter' do
        query
        expect(canary.sing[0][:data]).to eq :setup_method
        expect(canary.sing[1][:data]).to eq :filter_block
      end
    end
  end

  # Making sure base gem works
  describe '#self.filter' do
    let(:params) { { canary: canary } }

    before do
      searcher.filter do |scope, params|
        params[:canary].sing(:filter)
        scope.where(family: 'filter')
      end
    end

    it 'gets called' do
      query
      expect(canary.sing[0][:data]).to eq :filter
    end
  end

  describe '#self.distinct' do
    context 'when called with no args' do
      before do
        searcher.distinct
      end

      it 'distincts the query' do
        expect(query).to match(/DISTINCT/)
      end
    end

    context 'with args[0] => true' do
      before do
        searcher.distinct true
      end

      it 'sets distinct? to true' do
        expect(instance.distinct?).to be true
      end

      it 'distincts the query' do
        expect(query).to match(/DISTINCT/)
      end
    end

    context 'with args[0] => false' do
      it 'sets distinct? to false' do
        expect(instance.distinct?).to be false
      end

      it 'doesn\'t distinct the query' do
        expect(query).not_to match(/distinct/)
      end
    end
  end

  describe '#self.includes' do
    it 'sets included_params to nil by default' do
      expect(instance.included_params).to be_nil
    end

    it 'does not alter the query by default' do
      expect(instance.search(params).includes_values).not_to include(:person)
    end

    context 'when called with known relationships' do
      before do
        searcher.includes(:person)
      end

      it 'populates includes' do
        expect(instance.included_params).to eq([:person])
      end

      it 'alters the query to join' do
        expect(instance.search(params).includes_values).to include(:person)
      end
    end
  end

  describe '#self.order' do
    let(:params) { { canary: canary } }

    before do
      searcher.order do |scope, params|
        params[:canary].sing(:order_block)
        scope.where(tribe: 'order_block')
      end

      searcher.filter do |scope, params|
        params[:canary].sing(:filter_block)
        scope.where(family: 'filter')
      end
    end

    context 'with a block' do
      it 'calls the order block' do
        expect(query).to match(/"animals"."tribe" = 'order_block'/)
      end

      it 'calls order after filter' do
        query
        expect(canary.sing[0][:data]).to eq :filter_block
        expect(canary.sing[1][:data]).to eq :order_block
      end
    end

    context 'with a method' do
      before do
        searcher.define_method(:order_method) do |scope, params|
          params[:canary].sing(:order_method)
          scope.where(tribe: 'order_method')
        end

        searcher.order(:order_method)
      end

      it 'calls the order method' do
        expect(query).to match(/"animals"."tribe" = 'order_method'/)
      end

      it 'calls order after filter' do
        query
        expect(canary.sing[0][:data]).to eq :filter_block
        expect(canary.sing[1][:data]).to eq :order_method
      end
    end
  end

  describe '#self.order_by' do
    context 'with args[0] => and args[1] => value' do
      before do
        searcher.order_by :tribe, :desc
      end

      it 'sets the order_by method\'s value' do
        expect(instance.order_by).to eq :tribe
      end

      it 'sets the order method\'s value' do
        expect(instance.order).to eq :desc
      end
    end

    context 'with args[0] => and args[1] => nil' do
      before do
        searcher.order_by :phylum
      end

      it 'sets the order_by method\'s value' do
        expect(instance.order_by).to eq :phylum
      end

      it 'leaves order to default' do
        expect(instance.order).to eq 'ASC'
      end
    end
  end

  describe '#distinct?' do
    it 'defaults to false' do
      expect(instance.distinct?).to be false
    end

    it 'gets set by #self.distinct' do
      searcher.distinct true
      expect(instance.distinct?).to be true
    end
  end

  describe '#order_by' do
    it 'defaults to :id' do
      expect(instance.order_by).to eq :id
    end

    context 'when args[:order_by]' do
      context 'when the param is a model attribute' do
        it 'uses the provided param' do
          expect(instance.order_by(order_by: :phylum)).to eq :phylum
        end
      end

      context 'when the param isn\'t a model attribute' do
        it 'defaults to :id' do
          expect(instance.order_by(order_by: :fake)).to eq :id
        end
      end
    end

    context 'when set by #self.order_by' do
      before do
        searcher.order_by :name
      end

      it 'uses the attr set in #self.order_by' do
        expect(instance.order_by).to eq :name
      end

      context 'when args[:order_by]' do
        context 'when the param is a model attribute' do
          it 'uses the provided param' do
            expect(instance.order_by(order_by: :phylum)).to eq :phylum
          end
        end

        context 'when the param isn\'t a model attribute' do
          it 'uses the attr set in #self.order_by' do
            expect(instance.order_by).to eq :name
          end
        end
      end
    end
  end

  describe '#order' do
    it 'defaults to ASC' do
      expect(instance.order).to eq 'ASC'
    end

    context 'when args[:order]' do
      context 'when the param is a valid direction' do
        it 'uses the provided param' do
          expect(instance.order(order: :desc)).to eq 'DESC'
        end
      end

      context 'when the param isn\'t a valid direction' do
        it 'defaults to :id' do
          expect(instance.order(order: :fake)).to eq 'ASC'
        end
      end
    end

    context 'when set by #self.order_by' do
      before do
        searcher.order_by :name, 'DESC'
      end

      it 'uses the attr set in #self.order_by' do
        expect(instance.order).to eq 'DESC'
      end

      context 'when args[:order]' do
        context 'when the param is a valid direction' do
          it 'uses the provided param' do
            expect(instance.order(order: :asc)).to eq 'ASC'
          end
        end

        context 'when the param isn\'t a valid direction' do
          it 'defaults to :id' do
            expect(instance.order(order: :fake)).to eq 'DESC'
          end
        end
      end
    end
  end

  describe '#search' do
    let(:params) { { canary: canary } }

    before do
      searcher.distinct

      searcher.setup do |scope, params|
        params[:canary].sing(:setup)
        scope
      end

      searcher.filter do |scope, params|
        params[:canary].sing(:filter1)
        scope
      end

      searcher.filter do |scope, params|
        params[:canary].sing(:filter2)
        scope
      end

      searcher.order do |scope, params|
        params[:canary].sing(:order)
        scope
      end
    end

    it 'calls setup' do
      query
      expect(canary.sung?(:setup)).to be true
    end

    it 'calls all filters' do
      query
      expect(canary.sung?(:filter1)).to be true
      expect(canary.sung?(:filter2)).to be true
      expect(canary.sung?(:filter3)).to be false
    end

    it 'calls order' do
      query
      expect(canary.sung?(:order)).to be true
    end

    it 'applies distinct' do
      expect(query).to match(/DISTINCT/)
    end
  end
end

class TestSearcherClass
  include SnFoil::Searcher
end
