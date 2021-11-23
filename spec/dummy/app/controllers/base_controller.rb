# frozen_string_literal: true

class BaseController < ApplicationController
  include SnFoil::Controller

  endpoint :show do |**_options|
    render json: Animal.find(params[:id]), status: :ok
  end
end
