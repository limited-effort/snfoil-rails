# frozen_string_literal: true

# Copyright 2025 Matthew Howes

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative '../concerns/inject_deserialized'
require_relative '../concerns/inject_request_params'
require_relative '../concerns/inject_request_id'
require 'snfoil/controller'

module SnFoil
  module Rails
    module API
      module Create
        extend ActiveSupport::Concern

        included do
          include SnFoil::Controller

          include InjectRequestId
          include InjectDeserialized
          include InjectInclude
          include InjectRequestParams

          endpoint :create, with: :render_create

          setup_create with: :inject_request_id
          setup_create with: :inject_request_params
          setup_create with: :inject_deserialized
          setup_create with: :inject_include

          process_create with: :run_context

          def render_create(**options)
            if options[:object].errors.empty?
              render json: serialize(options[:object], **options), status: :created
            else
              render json: options[:object].errors, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
