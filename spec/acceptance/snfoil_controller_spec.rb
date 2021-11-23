# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe 'SnFoil::Controller', type: :controller do
  before { @controller = BaseController.new }

  describe 'testing an enpoint' do
    let(:person) { Person.create!(name: 'Joe') }
    let(:animal) { Animal.create!(name: 'Cat', person: person) }

    it 'correctly processes the call' do
      get :show, params: { id: animal.id }
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:id]).to eq animal.id
    end
  end
end
