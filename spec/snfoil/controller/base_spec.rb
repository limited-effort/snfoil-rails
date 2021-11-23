# frozen_string_literal: true

require 'rails_helper'
require 'snfoil/controller/base'

RSpec.describe SnFoil::Controller::Base do
  let(:controller) { described_class }

  it 'includes ChangeControllerConcern' do
    expect(controller.ancestors).to include(SnFoil::Controller::Concerns::ChangeControllerConcern)
  end

  it 'includes CreateControllerConcern' do
    expect(controller.ancestors).to include(SnFoil::Controller::Concerns::CreateControllerConcern)
  end

  it 'includes DestroyControllerConcern' do
    expect(controller.ancestors).to include(SnFoil::Controller::Concerns::DestroyControllerConcern)
  end

  it 'includes IndexControllerConcern' do
    expect(controller.ancestors).to include(SnFoil::Controller::Concerns::IndexControllerConcern)
  end

  it 'includes ShowControllerConcern' do
    expect(controller.ancestors).to include(SnFoil::Controller::Concerns::ShowControllerConcern)
  end

  it 'includes UpdateControllerConcern' do
    expect(controller.ancestors).to include(SnFoil::Controller::Concerns::UpdateControllerConcern)
  end
end
