# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::JsonapiSerializer do
  let(:including_class) { TestSerializer }

  it 'includes ChangeControllerConcern' do
    expect(including_class.ancestors).to include(FastJsonapi::ObjectSerializer)
  end
end

class TestSerializer
  include SnFoil::JsonapiSerializer
  include SnFoil::Configuration::LazyJsonapiSerializer
end
