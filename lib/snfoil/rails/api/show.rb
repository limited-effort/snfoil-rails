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

require_relative '../concerns/inject_id'
require_relative '../concerns/inject_include'
require_relative '../concerns/inject_request_params'
require_relative '../concerns/inject_request_id'
require 'snfoil/controller'

module SnFoil
  module Rails
    module API
      module Show
        extend ActiveSupport::Concern

        included do
          include SnFoil::Controller

          include InjectRequestId
          include InjectId
          include InjectInclude
          include InjectRequestParams

          endpoint :show, with: :render_show

          setup_show with: :inject_request_id
          setup_show with: :inject_request_params
          setup_show with: :inject_id
          setup_show with: :inject_include

          process_show with: :run_context

          def render_show(**options)
            render json: serialize(options[:object], **options), status: :ok
          end
        end
      end
    end
  end
end
