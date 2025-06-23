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
