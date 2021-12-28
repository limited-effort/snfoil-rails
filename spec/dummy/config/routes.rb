# frozen_string_literal: true

Rails.application.routes.draw do
  # get '/base/:id', to: 'base#show'

  post '/api/animal/create', to: 'api/create#create'
  get '/api/animal/show/:id', to: 'api/show#show'
  put '/api/animal/update/:id', to: 'api/update#update'
  delete '/api/animal/destroy/:id', to: 'api/destroy#destroy'
  get '/api/animal/index', to: 'api/index#index'
end
