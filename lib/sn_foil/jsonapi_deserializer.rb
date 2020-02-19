# frozen_string_literal: true

require 'active_support/concern'

module SnFoil
  module JsonapiDeserializer # rubocop:disable Metrics/ModuleLength
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :i_attribute_fields, :i_attribute_transforms

      def attributes(*fields)
        @i_attribute_fields ||= []
        @i_attribute_fields |= fields
      end

      def attribute(key, **options)
        @i_attribute_transforms ||= {}
        @i_attribute_transforms[key] = options.merge(transform_type: :attribute)
      end

      def has_one(key, deserializer:, **options) # rubocop:disable Naming/PredicateName
        @i_attribute_transforms ||= {}
        @i_attribute_transforms[key] = options.merge(deserializer: deserializer, transform_type: :has_one)
      end
      alias_method :belongs_to, :has_one

      def has_many(key, deserializer:, **options) # rubocop:disable Naming/PredicateName
        @i_attribute_transforms ||= {}
        @i_attribute_transforms[key] = options.merge(deserializer: deserializer, transform_type: :has_many)
      end
    end

    attr_reader :object, :included, :options
    def initialize(object, included: nil, **options)
      @object = object
      @included = included || object[:included]
      @options = options
    end

    def attribute_fields
      self.class.i_attribute_fields || []
    end

    def attribute_transforms
      self.class.i_attribute_transforms || {}
    end

    def attributes
      @attributes ||= attribute_fields | attribute_transforms.map { |k, v| v[:key] || k }
    end

    def parse
      parse_data
    end
    alias to_h parse

    private

    def parse_data
      if object[:data].is_a? Array
        object[:data].map { |d| build_attributes(d) }
      else
        build_attributes(object[:data])
      end
    end

    def build_attributes(data)
      attributes = data_id({}, data)
      attributes = parse_standard_attributes(attributes, data) if data[:attributes]
      attribute_transforms.each do |key, opts|
        attributes = apply_attribute_transform(attributes, data, key, **opts)
      end
      attributes
    end

    def data_id(attributes, data)
      if data[:id]
        attributes[:id] = data[:id]
      elsif object[:data][:lid]
        attributes[:lid] = data[:lid]
      end
      attributes
    end

    def parse_standard_attributes(attributes, data)
      attributes.merge!(data[:attributes].select { |k, _| attribute_fields.include? k })
    end

    def apply_attribute_transform(attributes, data, key, transform_type:, **opts)
      if transform_type == :attribute
        parse_attribute_transform(attributes, data, key, **opts)
      elsif transform_type == :has_one
        parse_has_one_relationship(attributes, data, key, **opts)
      elsif transform_type == :has_many
        parse_has_many_relationship(attributes, data, key, **opts)
      end
    end

    def parse_attribute_transform(attributes, data, key, **opts)
      return attributes unless data.dig(:attributes, key)

      attributes.merge(Hash[opts.fetch(:key) { key }, data[:attributes][key]])
    end

    def parse_relationships(attributes, data)
      self.class.has_one_relationships.each do |key, opts|
        attributes = has_one_relationship(attributes, data, key, **opts)
      end
      self.class.has_many_relationships.each do |key, opts|
        attributes = has_many_relationship(attributes, data, key, **opts)
      end
      attributes
    end

    def parse_has_one_relationship(attributes, data, key, deserializer:, **opts)
      resource_data = data.dig(:relationships, key, :data)
      return attributes unless resource_data

      attribute_data = lookup_relationship(resource_data)
      relationship_data = { data: attribute_data || resource_data }
      attributes[opts.fetch(:key) { key }] = deserializer.new(relationship_data, **options, included: included).parse
      attributes
    end

    def parse_has_many_relationship(attributes, data, key, deserializer:, **opts)
      array_data = data.dig(:relationships, key, :data)
      return attributes unless array_data

      attributes[opts.fetch(:key) { key }] = array_data.map do |resource_data|
        attribute_data = lookup_relationship(resource_data)
        relationship_data = { data: attribute_data || resource_data }
        deserializer.new(relationship_data, **options, included: included).parse
      end
      attributes
    end

    def lookup_relationship(type:, id: nil, lid: nil, **_opts)
      raise ::ArguementError, 'missing keyword: id or lid' unless id || lid

      included&.find do |x|
        x[:type].eql?(type) &&
          if id
            x[:id].eql?(id)
          elsif lid
            x[:lid].eql?(lid)
          end
      end
    end
  end
end
