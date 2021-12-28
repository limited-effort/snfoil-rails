# frozen_string_literal: true

module Api
  class DestroyController < ActionController::API
    include SnFoil::Rails::API::Destroy

    context AnimalContext
  end
end
