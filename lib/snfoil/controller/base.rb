# frozen_string_literal: true

require_relative 'concerns/create_controller_concern'
require_relative 'concerns/destroy_controller_concern'
require_relative 'concerns/index_controller_concern'
require_relative 'concerns/show_controller_concern'
require_relative 'concerns/update_controller_concern'

module SnFoil
  module Controller
    class Base < ActionController::Base # rubocop:disable Rails/ApplicationController
      include Concerns::CreateControllerConcern
      include Concerns::DestroyControllerConcern
      include Concerns::IndexControllerConcern
      include Concerns::ShowControllerConcern
      include Concerns::UpdateControllerConcern
    end
  end
end
