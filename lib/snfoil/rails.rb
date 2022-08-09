# frozen_string_literal: true

module SnFoil
  module Rails
    require 'snfoil/rails/engine' if Object.const_defined?(:Rails)
  end
end
