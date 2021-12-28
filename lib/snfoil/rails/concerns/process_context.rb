# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module ProcessContext
      extend ActiveSupport::Concern

      def process_context(**options)
        current_context = options[:context] ||= context
        current_context.new(entity).send(options[:context_action], **options)
      end
    end
  end
end
