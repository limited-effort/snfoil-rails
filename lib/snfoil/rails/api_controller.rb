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

require_relative 'api/create'
require_relative 'api/destroy'
require_relative 'api/index'
require_relative 'api/show'
require_relative 'api/update'

module SnFoil
  module Rails
    class APIController < ActionController::API
      include SnFoil::Rails::API::Create
      include SnFoil::Rails::API::Show
      include SnFoil::Rails::API::Update
      include SnFoil::Rails::API::Destroy
      include SnFoil::Rails::API::Index
    end
  end
end
