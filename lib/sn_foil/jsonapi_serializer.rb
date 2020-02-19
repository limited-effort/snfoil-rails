# frozen_string_literal: true

require 'active_support/concern'
require 'fast_jsonapi/object_serializer'

module SnFoil
  module JsonapiSerializer
    extend ActiveSupport::Concern

    included do
      include FastJsonapi::ObjectSerializer

      set_key_transform :dash
    end
  end
end
