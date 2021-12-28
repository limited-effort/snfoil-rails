# frozen_string_literal: true

module SnFoil
  module Rails
    if Object.const_defined?(:Rails)
      require 'snfoil/rails/engine'
    else
      require 'snfoil'
      require_relative 'rails/searcher'

      require_relative 'rails/api/create'
      require_relative 'rails/api/destroy'
      require_relative 'rails/api/index'
      require_relative 'rails/api/show'
      require_relative 'rails/api/update'
      require_relative 'rails/api_controller'
    end
  end
end
