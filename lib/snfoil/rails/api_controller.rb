# frozen_string_literal: true

require_relative 'api/create'
require_relative 'api/destroy'
require_relative 'api/index'
require_relative 'api/show'
require_relative 'api/update'

module SnFoil
  module Rails
    class APIController < ActionController::API
      include SnFoil::Rails::API::Create
      include SnFoil::Rails::API::Show
      include SnFoil::Rails::API::Update
      include SnFoil::Rails::API::Destroy
      include SnFoil::Rails::API::Index
    end
  end
end
