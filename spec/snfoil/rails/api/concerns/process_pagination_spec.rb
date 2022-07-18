# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::ProcessPagination, type: :concern do
  subject(:including_class) { ProcessPaginationStub.clone }

  let(:including_class_instance) { including_class.new }
  let(:page) { 2 }
  let(:per_page) { 25 }
  let(:object) { Animal.all }
  let(:options) do
    { request_params: { page: page, per_page: per_page }, object: object }
  end

  before do
    including_class.include described_class
    create_list(:animal, 61)
  end

  describe '#paginate' do
    it 'defaults to paginating with kaminari' do
      expect(including_class_instance.paginate(**options).count).to eq 25
    end

    context 'when kaminari isn\'t available' do
      let(:object) { Animal.all.to_a }

      it 'doesn\'t scope the results' do
        expect(including_class_instance.paginate(**options).count).to eq 61
      end
    end
  end

  describe '#pagination_page' do
    it 'returns the page from request_params' do
      expect(including_class_instance.pagination_page(**options)).to eq 2
    end

    context 'when page isn\'t in the request_params' do
      let(:options) { { object: Animal.all } }

      it 'returns 1' do
        expect(including_class_instance.pagination_page(**options)).to eq 1
      end
    end
  end

  describe '#pagination_per_page' do
    it 'returns the per_page from request_params' do
      expect(including_class_instance.pagination_per_page(**options)).to eq 25
    end

    context 'when per_page isn\'t in the request_params' do
      let(:options) { { object: Animal.all } }

      it 'returns 10' do
        expect(including_class_instance.pagination_per_page(**options)).to eq 10
      end
    end

    context 'when request_params[:per_page] = 0' do
      let(:per_page) { 0 }

      it 'returns 1000' do
        expect(including_class_instance.pagination_per_page(**options)).to eq 1000
      end
    end

    context 'when request_params[:per_page] > 1000' do
      let(:per_page) { 9000 }

      it 'returns 1000' do
        expect(including_class_instance.pagination_per_page(**options)).to eq 1000
      end
    end
  end

  describe '#pagination_pages' do
    it 'returns the calculated total pages' do
      expect(including_class_instance.pagination_per_page(**options)).to eq 25
    end
  end

  describe '#pagination_count' do
    it 'returns all items in scope' do
      expect(including_class_instance.pagination_pages(**options)).to eq 3
    end
  end

  describe '#pagination_meta' do
    it 'creates a hash of the relevant information' do
      expect(including_class_instance.pagination_meta(**options)[:page]).to eq 2
      expect(including_class_instance.pagination_meta(**options)[:pages]).to eq 3
      expect(including_class_instance.pagination_meta(**options)[:total]).to eq 61
      expect(including_class_instance.pagination_meta(**options)[:per]).to eq 25
    end
  end

  describe '#process_pagination' do
    it 'inject meta into the options' do
      expect(options.keys).not_to include :meta
      expect(including_class_instance.process_pagination(**options).keys).to include :meta
    end

    it 'injects the pagination scope into options[:object]' do
      expect(including_class_instance.process_pagination(**options)[:object].count).to eq 25
    end
  end
end

class ProcessPaginationStub # rubocop:disable Lint/EmptyClass
end
