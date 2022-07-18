# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::API::Update do
  subject(:including_class) { ApiUpdateStub.clone }

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

  it 'includes InjectId' do
    expect(including_class.ancestors).to include SnFoil::Rails::InjectId
  end

  it 'sets up #update endpoint with #render_update as render method' do
    expect(including_class.snfoil_endpoints).to include :update
    expect(including_class.snfoil_endpoints[:update][:with]).to eq :render_update
  end

  it 'adds #render_update' do
    expect(including_class_instance).to respond_to :render_update
  end

  it 'adds #inject_request_params at setup' do
    hooks = including_class.snfoil_setup_update_hooks.pluck(:method)
    expect(hooks).to include :inject_request_params
  end

  it 'adds #inject_request_id at setup' do
    hooks = including_class.snfoil_setup_update_hooks.pluck(:method)
    expect(hooks).to include :inject_request_id
  end

  it 'adds #inject_deserialized at setup' do
    hooks = including_class.snfoil_setup_update_hooks.pluck(:method)
    expect(hooks).to include :inject_deserialized
  end

  it 'adds #inject_include at setup' do
    hooks = including_class.snfoil_setup_update_hooks.pluck(:method)
    expect(hooks).to include :inject_include
  end

  it 'adds #inject_id at setup' do
    hooks = including_class.snfoil_setup_update_hooks.pluck(:method)
    expect(hooks).to include :inject_id
  end
end

class ApiUpdateStub # rubocop:disable Lint/EmptyClass
end
