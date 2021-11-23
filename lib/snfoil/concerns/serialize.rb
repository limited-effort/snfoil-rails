# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module Serialize
      extend ActiveSupport::Concern
      def serialize(object, **options)
        serializer = options.fetch(:serializer) { serializer }
        return object unless serializer

        serializer.new(object, **options, current_entity: entity).serializable_hash
      end
    end
  end
end
