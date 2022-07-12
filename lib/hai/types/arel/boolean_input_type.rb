module Hai
  module GraphQL
    module Types
      module Arel
        class BooleanInputType < ::GraphQL::Schema::InputObject
          argument :eq, ::GraphQL::Types::Boolean
        end
      end
    end
  end
end
