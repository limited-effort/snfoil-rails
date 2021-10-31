require_relative 'controller'
require_relative 'concerns/inject_controller_params'
require_relative 'concerns/inject_deserialized'
require_relative 'concerns/inject_id'
require_relative 'concerns/inject_includes'
require_relative 'concerns/process_context'
require_relative 'concerns/serialize'

module SnFoil
  module Rails
    class BasicController
      include SnFoil::Controller

      class << self
        def endpoint(name, **options, &block)
          super(name,
                **options,
                context_action: options.fetch(:context_action, name),
                deserialize: options.fetch(:deserialize, true),
                &block)

          send("setup_#{name}", :inject_controller_params)
          send("setup_#{name}", :inject_deserialized_params)
          send("setup_#{name}", :inject_id)
          send("setup_#{name}", :inject_includes)
          send("process_#{name}", :process_context)
        end
      end
    end
  end
end
