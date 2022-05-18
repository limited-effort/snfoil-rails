# frozen_string_literal: true

FactoryBot.define do
  factory :animal do
    name { SecureRandom.uuid }
  end
end
