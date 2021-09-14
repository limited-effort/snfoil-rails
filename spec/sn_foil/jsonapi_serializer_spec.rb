# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::JsonapiSerializer do
  let(:including_class) { TestSerializer }

  it 'includes JSONAPI::Serializer' do
    expect(including_class.ancestors).to include(JSONAPI::Serializer)
  end
end

class TestSerializer
  include SnFoil::JsonapiSerializer
end
