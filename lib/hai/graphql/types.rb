require "hai/types/arel/int_input_type"
require "hai/types/arel/string_input_type"
require "hai/types/arel/datetime_input_type"

module Hai
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
            if name == ref.plural_name
              klass.send(:field, name, "[Types::#{ref.klass}Type]")
            else
              klass.send(:field, name, "Types::#{ref.klass}Type")
            end
          end

          # input objects
          klass = Class.new(::Types::BaseInputObject)
          klass.description("Attributes for creating or updating a #{model}.")
          model.attribute_types.each do |attr, type|
            next if %w[id created_at updated_at].include?(attr)

            klass.argument(attr, Hai::GraphQL::TYPE_CAST[type.class], required: false)
          end
          ::Types.const_set "#{model}Attributes", klass
        end
      end
    end
  end
end
