# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module Rails
    module InjectId
      extend ActiveSupport::Concern

      def inject_id(**options)
        return options if options[:id]

        options[:id] = id if defined? id
        options[:id] ||= options[:params][:id]
        options
      end
    end
  end
end
