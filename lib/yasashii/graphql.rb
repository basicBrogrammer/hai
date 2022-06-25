require "yasashii/graphql/read_queries"
require "yasashii/graphql/list_queries"
require "yasashii/graphql/create_mutations"
require "yasashii/types/arel/int_input_type"
require "yasashii/types/arel/string_input_type"
require "yasashii/types/arel/datetime_input_type"

module Yasashii
  module GraphQL
    TYPE_CAST = {
      ActiveModel::Type::Integer => ::GraphQL::Types::Int,
      ActiveModel::Type::String => ::GraphQL::Types::String,
      ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter => ::GraphQL::Types::ISO8601DateTime
    }.freeze
    AREL_TYPE_CAST = {
      ActiveModel::Type::Integer => Yasashii::GraphQL::Types::Arel::IntInputType,
      ActiveModel::Type::String => Yasashii::GraphQL::Types::Arel::StringInputType,
      ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter => Yasashii::GraphQL::Types::Arel::DateTimeInputType
    }.freeze
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def yasashii_query(model)
        Yasashii::GraphQL::ReadQueries.add(self, model)
        Yasashii::GraphQL::ListQueries.add(self, model)
      end

      def yasashii_mutation(model)
        Yasashii::GraphQL::CreateMutations.add(self, model)
      end
    end
  end
end
