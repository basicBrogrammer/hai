# frozen_string_literal: true

# TODO: remove dependency on Graphql
require "graphql"
require "active_record"

require_relative "hai/version"
require_relative "hai/read"
require_relative "hai/create"
require_relative "hai/update"
require_relative "hai/delete"
require_relative "hai/graphql"
require_relative "hai/policies"
require_relative "hai/graphql/types"

module Hai
  class Error < StandardError; end
  # Your code goes here...
end
