# frozen_string_literal: true

# Copyright 2021 Matthew Howes

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module SnFoil
  class JsonapiSerializerGenerator < ::Rails::Generators::Base
    def self.base_name
      'snfoil'
    end

    namespace 'snfoil:jsonapi_serializer'
    source_root File.expand_path('templates', __dir__)

    argument :model, type: :string

    class_option :path, desc: 'Base path for file', type: :string, default: 'app/jsonapi_serializers'

    def add_app_file
      file_name = if modules.empty?
                    name
                  else
                    "#{modules.join('/')}/#{name}"
                  end

      template('jsonapi_serializer.erb', "#{options[:path]}/#{file_name}_jsonapi_serializer.rb")
    end

    private

    def name
      @name ||= model.split('/').last.underscore.singularize
    end

    def class_name
      @class_name ||= name.camelize
    end

    def modules
      @modules ||= model.split('/')[0..-2].map(&:underscore)
    end

    def class_modules
      return if modules.empty?

      @class_modules ||= "#{modules.map(&:camelize).join('::')}::"
    end
  end
end
