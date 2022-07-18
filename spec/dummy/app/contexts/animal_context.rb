# frozen_string_literal: true

class AnimalContext
  include SnFoil::CRUD::Context

  model Animal
  searcher AnimalSearcher
  policy AnimalPolicy

  before_create with: :sing
  after_index with: :sing

  def sing(**options)
    options[:canary]&.sing(options)

    options
  end
end
