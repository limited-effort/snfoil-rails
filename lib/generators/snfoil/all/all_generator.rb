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
  class AllGenerator < ::Rails::Generators::Base
    def self.base_name
      'snfoil'
    end

    namespace 'snfoil:all'
    source_root File.expand_path('templates', __dir__)

    argument :model, type: :string

    class_option(:type, desc: 'Generate Base or API', type: :string, default: 'base')
    class_option(:skip_model, desc: 'Skip Model Creation', type: :boolean, default: false)

    def add_model
      return if options[:skip_model]

      rails_command "generate model #{call_args.join(' ')}", call_options
    end

    def add_policy
      rails_command "generate snfoil:policy #{call_args.join(' ')}", call_options
    end

    def add_searcher
      rails_command "generate snfoil:searcher #{call_args.join(' ')}", call_options
    end

    def add_context
      rails_command "generate snfoil:context #{call_args.join(' ')}", call_options
    end

    def add_jsonapi_serializer
      rails_command "generate snfoil:jsonapi_serializer #{call_args.join(' ')}", call_options
    end

    def add_jsonapi_deserializer
      rails_command "generate snfoil:jsonapi_deserializer #{call_args.join(' ')}", call_options
    end

    def add_controller
      rails_command "generate snfoil:controller #{call_args.join(' ')}", call_options
    end

    private

    def call_args
      @call_args ||= [model].concat(args)
    end

    def call_options
      @call_options ||= options.deep_symbolize_keys
    end
  end
end
