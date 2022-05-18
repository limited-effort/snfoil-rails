# frozen_string_literal: true

class Animal < ApplicationRecord
  belongs_to :person, optional: true

  validates :name, presence: true
end
