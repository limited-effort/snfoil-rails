# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::AnimalsController, type: :controller do
  describe 'GET index' do
    before do
      create_list(:animal, 92)
      get :index
    end

    it 'respects page' do
      json = JSON.parse(response.body)
      expect(json['meta']['page']).to eq 1
    end

    it 'respects per_page' do
      json = JSON.parse(response.body)
      expect(json['meta']['per']).to eq 10
    end

    it 'returns total' do
      json = JSON.parse(response.body)
      expect(json['meta']['total']).to eq 92
    end

    it 'returns pages' do
      json = JSON.parse(response.body)
      expect(json['meta']['pages']).to eq 10
    end

    it 'responds with serialized data' do
      json = JSON.parse(response.body)
      expect(json['animal'].count).to eq 10
    end
  end

  describe 'GET show' do
    let(:animal) { create(:animal) }

    it 'responds with serialized data' do
      get :show, params: { id: animal.id }
      json = JSON.parse(response.body)
      expect(json['animal']['id']).to eq animal.id
    end
  end

  describe 'POST :create' do
    let(:animal) { attributes_for(:animal) }

    it 'creates the object' do
      expect do
        post :create, params: { animal: animal }
      end.to change(Animal, :count).by(1)
    end

    it 'responds with serialized data' do
      post :create, params: { animal: animal }
      json = JSON.parse(response.body)
      expect(json['animal']['id']).to be_positive
      expect(json['animal']['name']).to eq animal[:name]
    end
  end

  describe 'PUT :update' do
    let(:animal) { create(:animal) }

    it 'updates the object' do
      put :update, params: { id: animal.id, animal: { name: 'Alex Lifeson' } }
      expect(animal.reload.name).to eq('Alex Lifeson')
    end

    it 'responds with serialized data' do
      put :update, params: { id: animal.id, animal: { name: 'Alex Lifeson' } }
      json = JSON.parse(response.body)
      expect(json['animal']['id']).to eq animal.id
    end
  end

  describe 'DELETE :destroy' do
    let(:animal) { create(:animal) }

    it 'destroys the object' do
      delete :destroy, params: { id: animal.id }
      expect do
        animal.reload
      end.to raise_error ActiveRecord::RecordNotFound
    end

    it 'responds with 204' do
      delete :destroy, params: { id: animal.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
