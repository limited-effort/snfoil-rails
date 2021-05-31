# frozen_string_literal: true

module SnFoil
  module Configuration
    module LazyJsonapiSerializer
      extend ActiveSupport::Concern

      class << self
        def belongs_to(relationship_name, options = {}, &block)
          block = belongs_to_optimized_block(relationship_name, options, &block)
          super(relationship_name, options, &block)
        end

        def has_one(relationship_name, options = {}, &block) # rubocop:disable Naming/PredicateName reason: method override
          super(relationship_name, has_relation_optimized_options(relationship_name, options), &block)
        end

        def has_many(relationship_name, options = {}, &block) # rubocop:disable Naming/PredicateName reason: method override
          super(relationship_name, has_relation_optimized_options(relationship_name, options), &block)
        end

        private

        # We need to parse the include block because FastJsonAPI does not allow access to the pre-parsed includes
        def parse_include(params)
          return [] unless params[:include]

          if params[:include].is_a?(String)
            params[:include].split(',')
          else
            params[:include]
          end.map { |r| r.to_s.dasherize }.join(',')
        end

        def lookup_full_object_for_belongs_to(record, relationship_name, options, params)
          return unless parse_include(params).include?(relationship_name.to_s.dasherize)

          record.send(options[:object_method_name] || relationship_name)
        end

        def create_substitute_object_for_belongs_to(record, relationship_name, options)
          relationship_id = options[:id_method_name] || "#{relationship_name}_id".to_sym
          OpenStruct.new(id: record.send(relationship_id))
        end

        def belongs_to_optimized_block(relationship_name, options = {}, &block)
          return block if options[:skip_optimization] == true || block

          proc do |record, params|
            if params && params[:include]
              lookup_full_object(record_for_belongs_to, relationship_name, options, params)
            else
              create_substitute_object_for_belongs_to(record, relationship_name, options)
            end
          end
        end

        def create_included_proc_for_has_relation(relationship_name)
          proc do |_record, params|
            if params && params[:include]
              parse_include(params).include?(relationship_name.to_s.dasherize)
            else
              false
            end
          end
        end

        def create_if_proc_for_has_relation(if_proc, included_proc)
          if if_proc.present?
            proc do |record, params|
              FastJsonapi.call_proc(if_proc, record, params) && FastJsonapi.call_proc(included_proc, record, params)
            end
          else
            included_proc
          end
        end

        def has_relation_optimized_options(relationship_name, options) # rubocop:disable Naming/PredicateName reason: method override
          return options if options[:skip_optimization] == true

          options[:if] = create_if_proc_for_has_relation(options[:if], create_included_proc_for_has_relation(relationship_name))
          options
        end
      end
    end
  end
end
