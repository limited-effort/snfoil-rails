# frozen_string_literal: true

module Api
  class IndexController < ActionController::API
    include SnFoil::Rails::API::Index

    context AnimalContext
    serializer(AnimalSerializer) do |object, serializer, **_|
      serializer.render(object)
    end
  end
end
