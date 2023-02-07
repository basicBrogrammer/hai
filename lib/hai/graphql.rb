require "hai/graphql/read_queries"
require "hai/graphql/list_queries"
require "hai/graphql/create_mutations"
require "hai/graphql/update_mutations"
require "hai/graphql/delete_mutations"
require "hai/types/arel/int_input_type"
require "hai/types/arel/float_input_type"
require "hai/types/arel/string_input_type"
require "hai/types/arel/datetime_input_type"
require "hai/types/arel/boolean_input_type"

module Hai
  module GraphQL
    TYPE_CAST = {
      ActiveModel::Type::Integer => ::GraphQL::Types::Int,
      ActiveModel::Type::Float => ::GraphQL::Types::Float,
      ActiveModel::Type::String => ::GraphQL::Types::String,
      ActiveRecord::Type::Text => ::GraphQL::Types::String,
      ActiveModel::Type::Boolean => ::GraphQL::Types::Boolean,
      ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter =>
        ::GraphQL::Types::ISO8601DateTime
    }.freeze
    AREL_TYPE_CAST = {
      ActiveModel::Type::Integer => Hai::GraphQL::Types::Arel::IntInputType,
      ActiveModel::Type::Float => Hai::GraphQL::Types::Arel::FloatInputType,
      ActiveModel::Type::String => Hai::GraphQL::Types::Arel::StringInputType,
      ActiveRecord::Type::Text => Hai::GraphQL::Types::Arel::StringInputType,
      ActiveModel::Type::Boolean => Hai::GraphQL::Types::Arel::BooleanInputType,
      ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter =>
        Hai::GraphQL::Types::Arel::DateTimeInputType
    }.freeze

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def hai_query(*models)
        models.each do |model|
          Hai::GraphQL::ReadQueries.add(self, model)
          Hai::GraphQL::ListQueries.add(self, model)
        end
      end

      def hai_mutation(*models)
        models.each do |model|
          Hai::GraphQL::CreateMutations.add(self, model)
          Hai::GraphQL::UpdateMutations.add(self, model)
          Hai::GraphQL::DeleteMutations.add(self, model)
        end
      end
    end
  end
end
