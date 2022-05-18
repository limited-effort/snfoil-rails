# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnFoil::Rails::ProcessContext, type: :concern do
  subject(:including_class) { ProcessContextStub.clone }

  let(:including_class_instance) { including_class.new }

  before do
    including_class.include described_class
  end

  describe '#process_context' do
    it 'calls #run_context' do
      allow(including_class_instance).to receive(:run_context)
      including_class_instance.process_context(**{})
      expect(including_class_instance).to have_received(:run_context)
    end
  end
end

class ProcessContextStub
  include SnFoil::Controller
end
