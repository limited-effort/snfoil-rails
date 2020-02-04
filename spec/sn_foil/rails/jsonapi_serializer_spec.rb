# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::JsonapiSerializer do
  let(:including_class) { TestSerializer }

  it 'includes ChangeControllerConcern' do
    expect(including_class.ancestors).to include(FastJsonapi::ObjectSerializer)
  end
end

class TestSerializer
  include SnFoil::Rails::JsonapiSerializer
end
