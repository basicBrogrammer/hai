module Hai
  module GraphQL
    module Types
      class SortInputType < ::GraphQL::Schema::InputObject
        argument :field, ::GraphQL::Types::String # TODO: maybe add "types" dynamically?
        argument :order, ::GraphQL::Types::String # TODO: change to enum DESC||ASC
      end
    end
  end
end
