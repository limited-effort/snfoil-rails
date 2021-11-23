# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module InjectDeserialized
      extend ActiveSupport::Concern

      def inject_deserialized(**options)
        return options unless options[:params].present? && options[:deserialize] == true

        deserializer = options.fetch(:deserializer) { self.class.snfoil_deserializer }
        return unless deserializer

        options[:params] = deserializer.new(options[:params], **options).to_h
        options
      end
    end
  end
end
