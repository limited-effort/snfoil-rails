# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::APIController do
  it 'is a ActionControler::API' do
    expect(described_class.new).to be_a ActionController::API
  end

  it 'includes Create' do
    expect(described_class.ancestors).to include SnFoil::Rails::API::Create
  end

  it 'includes Show' do
    expect(described_class.ancestors).to include SnFoil::Rails::API::Show
  end

  it 'includes Update' do
    expect(described_class.ancestors).to include SnFoil::Rails::API::Update
  end

  it 'includes Destroy' do
    expect(described_class.ancestors).to include SnFoil::Rails::API::Destroy
  end

  it 'includes Index' do
    expect(described_class.ancestors).to include SnFoil::Rails::API::Index
  end
end
