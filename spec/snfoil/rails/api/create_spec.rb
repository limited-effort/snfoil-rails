# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::API::Create do
  subject(:including_class) { ApiCreateStub.clone }

  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
  end

  it 'includes InjectDeserialized' do
    expect(including_class.ancestors).to include SnFoil::Rails::InjectDeserialized
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

  it 'sets up #create endpoint with #render_create as render method' do
    expect(including_class.snfoil_endpoints).to include :create
    expect(including_class.snfoil_endpoints[:create][:with]).to eq :render_create
  end

  it 'adds #render_create' do
    expect(including_class_instance).to respond_to :render_create
  end

  it 'adds #inject_request_params at setup' do
    hooks = including_class.snfoil_setup_create_hooks.pluck(:method)
    expect(hooks).to include :inject_request_params
  end

  it 'adds #inject_request_id at setup' do
    hooks = including_class.snfoil_setup_create_hooks.pluck(:method)
    expect(hooks).to include :inject_request_id
  end

  it 'adds #inject_deserialized at setup' do
    hooks = including_class.snfoil_setup_create_hooks.pluck(:method)
    expect(hooks).to include :inject_deserialized
  end

  it 'adds #inject_include at setup' do
    hooks = including_class.snfoil_setup_create_hooks.pluck(:method)
    expect(hooks).to include :inject_include
  end
end

class ApiCreateStub # rubocop:disable Lint/EmptyClass
end
