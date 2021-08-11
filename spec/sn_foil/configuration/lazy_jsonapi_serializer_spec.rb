# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Configuration::LazyJsonapiSerializer do
  let(:including_class) { TestSerializer }

  it 'includes ChangeControllerConcern' do
    expect(including_class.ancestors).to include(FastJsonapi::ObjectSerializer)
  end
end

class TestLazySerializer
  include SnFoil::JsonapiSerializer
  include SnFoil::Configuration::LazyJsonapiSerializer
end
