module Hai
  module GraphQL
    module Types
      class MutationError < ::GraphQL::Schema::Object
        field :message, String
        field :code, Integer
        field :fields, [String], null: false
      end
    end
  end
end
