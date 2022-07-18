# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::API::Destroy do
  subject(:including_class) { ApiDestroyStub.clone }

  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
  end

  it 'includes InjectId' do
    expect(including_class.ancestors).to include SnFoil::Rails::InjectId
  end

  it 'includes InjectRequestParams' do
    expect(including_class.ancestors).to include SnFoil::Rails::InjectRequestParams
  end

  it 'includes InjectRequestId' do
    expect(including_class.ancestors).to include SnFoil::Rails::InjectRequestId
  end

  it 'sets up #destroy endpoint with #render_destroy as render method' do
    expect(including_class.snfoil_endpoints).to include :destroy
    expect(including_class.snfoil_endpoints[:destroy][:with]).to eq :render_destroy
  end

  it 'adds #render_destroy' do
    expect(including_class_instance).to respond_to :render_destroy
  end

  it 'adds #inject_request_params at setup' do
    hooks = including_class.snfoil_setup_destroy_hooks.pluck(:method)
    expect(hooks).to include :inject_request_params
  end

  it 'adds #inject_request_id at setup' do
    hooks = including_class.snfoil_setup_destroy_hooks.pluck(:method)
    expect(hooks).to include :inject_request_id
  end

  it 'adds #inject_id at setup' do
    hooks = including_class.snfoil_setup_destroy_hooks.pluck(:method)
    expect(hooks).to include :inject_id
  end
end

class ApiDestroyStub # rubocop:disable Lint/EmptyClass
end
