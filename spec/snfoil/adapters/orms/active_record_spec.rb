# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Adapters::ORMs::ActiveRecord do # rubocop:disable RSpec/SpecFilePathFormat
  it 'doesn\'t raise an association error with an ActiveRecord Model' do
    wrapped_class = described_class.new(Person).new
    expect(wrapped_class.is_a?(Person)).to be true
  end
end
