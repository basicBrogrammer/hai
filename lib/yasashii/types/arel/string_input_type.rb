module Yasashii
  module GraphQL
    module Types
      module Arel
        class StringInputType < ::GraphQL::Schema::InputObject
          ::Arel::Predications.instance_methods.each do |predication|
            # TODO: add these predications
            next if %i[in when].include?(predication)

            # TODO: find array predicates
            argument predication, ::GraphQL::Types::String, required: false
          end
        end
      end
    end
  end
end
