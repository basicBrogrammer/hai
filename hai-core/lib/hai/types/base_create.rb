require_relative "./mutation_error_type"

module Hai
  module GraphQL
    module Types
      # TODO: make this base class configurable?
      class BaseCreate < ::GraphQL::Schema::RelayClassicMutation
        null true

        field :errors, [String], null: false
      end
    end
  end
end
