# frozen_string_literal: true

require 'active_support/concern'
require 'jsonapi/serializer'

module SnFoil
  module JsonapiSerializer
    extend ActiveSupport::Concern

    included do
      include JSONAPI::Serializer

      set_key_transform :dash
    end
  end
end
