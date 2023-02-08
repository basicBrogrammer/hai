# frozen_string_literal: true

require "active_record"
# TODO: remove dependency on Graphql
require "graphql"
require_relative "hai/graphql"
require_relative "hai/graphql/types"

require_relative "hai/version"

require_relative "hai/read"
require_relative "hai/create"
require_relative "hai/update"
require_relative "hai/delete"
require_relative "hai/restricted_attributes"

require_relative "hai/policies"
require_relative "hai/action_mods"
require "hai/railtie" if defined?(Rails)
require "generators/rest/install_generator" if defined?(Rails)

module Hai
  class Error < StandardError
  end
  module Rest
    class Engine < ::Rails::Engine
      isolate_namespace Hai
    end
  end
end
