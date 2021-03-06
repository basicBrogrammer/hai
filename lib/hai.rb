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

require_relative "hai/policies"
require_relative "hai/action_mods"

module Hai
  class Error < StandardError; end
  # Your code goes here...
end
