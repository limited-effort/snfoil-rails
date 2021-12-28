# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module InjectDeserialized
      extend ActiveSupport::Concern

      def inject_deserialized(**options)
        options[:params] = deserialize(options[:params], **options)

        options
      end
    end
  end
end
