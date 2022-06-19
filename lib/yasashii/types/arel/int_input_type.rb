module Yasashii
  module GraphQL
    module Types
      module Arel
        class IntInputType < ::GraphQL::Schema::InputObject
          ::Arel::Predications.instance_methods.each do |predication|
            # TODO: add these predications
            next if %i[in when].include?(predication)

            # TODO: find array predicates
            argument predication, ::GraphQL::Types::Int, required: false
          end
        end
      end
    end
  end
end
