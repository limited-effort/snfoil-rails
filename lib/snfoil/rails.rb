# frozen_string_literal: true

module SnFoil
  module Rails
    if Object.const_defined?(:Rails)
      require 'snfoil/rails/engine'
    end
  end
end
