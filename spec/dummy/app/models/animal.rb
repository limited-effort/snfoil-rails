# frozen_string_literal: true

class Animal < ApplicationRecord
  belongs_to :person

  validates :name, presence: true
end
