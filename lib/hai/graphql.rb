require "hai/graphql/read_queries"
require "hai/graphql/list_queries"
require "hai/graphql/create_mutations"
require "hai/types/arel/int_input_type"
require "hai/types/arel/string_input_type"
require "hai/types/arel/datetime_input_type"

module Hai
  module GraphQL
    TYPE_CAST = {
      ActiveModel::Type::Integer => ::GraphQL::Types::Int,
      ActiveModel::Type::String => ::GraphQL::Types::String,
      ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter => ::GraphQL::Types::ISO8601DateTime
    }.freeze
    AREL_TYPE_CAST = {
      ActiveModel::Type::Integer => Hai::GraphQL::Types::Arel::IntInputType,
      ActiveModel::Type::String => Hai::GraphQL::Types::Arel::StringInputType,
      ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter => Hai::GraphQL::Types::Arel::DateTimeInputType
    }.freeze
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def yasashii_query(model)
        Hai::GraphQL::ReadQueries.add(self, model)
        Hai::GraphQL::ListQueries.add(self, model)
      end

      def yasashii_mutation(model)
        Hai::GraphQL::CreateMutations.add(self, model)
      end
    end
  end
end
