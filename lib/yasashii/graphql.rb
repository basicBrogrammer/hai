require "yasashii/types/arel/int_input_type"
require "yasashii/types/arel/string_input_type"
require "yasashii/types/arel/datetime_input_type"

module Yasashii
  module GraphQL
    module Types
      module Arel; end
      ALLOWED_TYPES = ::GraphQL::Types.constants - %i[Relay JSON]

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def yasashii_type(model)
          return if const_defined? "Types::#{model}Type"

          klass = Class.new(::Types::BaseObject)
          model.attribute_types.each do |attr, _type|
            klass.send(:field, attr, ::GraphQL::Types::String)
          end

          ::Types.const_set "#{model}Type", klass

          model.reflections.each do |name, ref|
            yasashii_type(ref.klass)
            klass.send(:field, name, "Types::#{ref.klass}Type")
          end
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      TYPE_CAST = {
        ActiveModel::Type::Integer => Yasashii::GraphQL::Types::Arel::IntInputType,
        ActiveModel::Type::String => Yasashii::GraphQL::Types::Arel::StringInputType,
        ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter => Yasashii::GraphQL::Types::Arel::DateTimeInputType
      }.freeze

      def yasashii_query(model)
        field "read_#{model.name.downcase}", "Types::#{model}Type".constantize do
          description "List a single #{model}."
          model.attribute_types.each do |attr, type|
            argument attr, TYPE_CAST[type.class], required: false
          end
        end

        define_method("read_#{model.name.downcase}") do |**args|
          Yasashii::Read.new(model).read(args.each_with_object({}) { |(k, input), acc| acc[k] = input.to_h })
        end
      end
    end
  end
end
