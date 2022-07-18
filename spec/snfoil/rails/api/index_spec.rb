# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::API::Index do
  subject(:including_class) { ApiIndexStub.clone }

  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
  end

  it 'includes InjectInclude' do
    expect(including_class.ancestors).to include SnFoil::Rails::InjectInclude
  end

  it 'includes InjectRequestParams' do
    expect(including_class.ancestors).to include SnFoil::Rails::InjectRequestParams
  end

  it 'includes InjectRequestId' do
    expect(including_class.ancestors).to include SnFoil::Rails::InjectRequestId
  end

  it 'includes ProcessPagination' do
    expect(including_class.ancestors).to include SnFoil::Rails::ProcessPagination
  end

  it 'sets up #index endpoint with #render_index as render method' do
    expect(including_class.snfoil_endpoints).to include :index
    expect(including_class.snfoil_endpoints[:index][:with]).to eq :render_index
  end

  it 'adds #render_index' do
    expect(including_class_instance).to respond_to :render_index
  end

  it 'adds #inject_request_params at setup' do
    hooks = including_class.snfoil_setup_index_hooks.pluck(:method)
    expect(hooks).to include :inject_request_params
  end

  it 'adds #inject_request_id at setup' do
    hooks = including_class.snfoil_setup_index_hooks.pluck(:method)
    expect(hooks).to include :inject_request_id
  end

  it 'adds #inject_include at setup' do
    hooks = including_class.snfoil_setup_index_hooks.pluck(:method)
    expect(hooks).to include :inject_include
  end
end

class ApiIndexStub # rubocop:disable Lint/EmptyClass
end
