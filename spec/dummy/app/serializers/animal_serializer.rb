# frozen_string_literal: true

class AnimalSerializer < Blueprinter::Base
  identifier :id

  fields :name, :kingdom, :phylum, :family, :subfamily, :tribe, :genus, :species
end
