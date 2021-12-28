# frozen_string_literal: true

module Api
  class ShowController < ActionController::API
    include SnFoil::Rails::API::Show

    context AnimalContext
    serializer(AnimalSerializer) do |object, serializer, **_|
      serializer.render(object)
    end
  end
end
