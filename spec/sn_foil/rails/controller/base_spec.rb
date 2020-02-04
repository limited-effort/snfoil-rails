# frozen_string_literal: true

require 'rails_helper'
require 'sn_foil/rails/controller/base'

RSpec.describe SnFoil::Rails::Controller::Base do
  let(:subject) { described_class }

  it 'includes ChangeControllerConcern' do
    expect(subject.ancestors).to include(SnFoil::Rails::Controller::Concerns::ChangeControllerConcern)
  end

  it 'includes CreateControllerConcern' do
    expect(subject.ancestors).to include(SnFoil::Rails::Controller::Concerns::CreateControllerConcern)
  end

  it 'includes DestroyControllerConcern' do
    expect(subject.ancestors).to include(SnFoil::Rails::Controller::Concerns::DestroyControllerConcern)
  end

  it 'includes IndexControllerConcern' do
    expect(subject.ancestors).to include(SnFoil::Rails::Controller::Concerns::IndexControllerConcern)
  end

  it 'includes ShowControllerConcern' do
    expect(subject.ancestors).to include(SnFoil::Rails::Controller::Concerns::ShowControllerConcern)
  end

  it 'includes UpdateControllerConcern' do
    expect(subject.ancestors).to include(SnFoil::Rails::Controller::Concerns::UpdateControllerConcern)
  end
end
