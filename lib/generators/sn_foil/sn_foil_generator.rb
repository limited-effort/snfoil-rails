# frozen_string_literal: true

class SnFoilGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  argument :model, type: :string

  def generate_sn_foil
    generate_model
    generate_controller
    generate_searcher
    generate_serializer
    generate_deserializer
    generate_policy
    generate_context
    puts 'In order to expose your model, it must be added to the config/routes.rb file'
  end

  private

  def generate_context
    template 'context.erb', "app/contexts/#{model.singularize.underscore}_context.rb"
  end

  def generate_controller
    template 'controller.erb', "app/controllers/#{model.pluralize.underscore}_controller.rb"
  end

  def generate_deserializer
    template 'jsonapi_deserializer.erb', "app/deserializers/#{model.singularize.underscore}_deserializer.rb"
  end

  def generate_serializer
    template 'jsonapi_serializer.erb', "app/serializers/#{model.singularize.underscore}_jsonapi_serializer.rb"
  end

  def generate_model
    generate('model', model.underscore) unless File.file? "app/models/#{model.singularize.underscore}.rb"
  end

  def generate_searcher
    template 'searcher.erb', "app/searchers/#{model.pluralize.underscore}_searcher.rb"
  end

  def generate_policy
    template 'policy.erb', "app/policies/#{model.singularize.underscore}_policy.rb"
  end
end
