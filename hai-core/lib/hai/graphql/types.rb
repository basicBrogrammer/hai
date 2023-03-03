require "hai/types/arel/int_input_type"
require "hai/types/arel/string_input_type"
require "hai/types/arel/datetime_input_type"

module Hai
  module GraphQL
    module Types
      module Arel
      end
      ALLOWED_TYPES = ::GraphQL::Types.constants - %i[Relay JSON]

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def hai_types(*models)
          base_types = models.map(&method(:define_base_type))
          models.each do |model|
            model.reflections.map(&method(:add_base_type_reflections))
          end

          models.map(&method(:define_input_object))
          filter_types = models.map(&method(:define_filter_type))
          models.each do |model|
            model.reflections.map(&method(:add_filter_type_reflections))
          end

          filter_types.each do |filter_type|
            filter_type.send(
              :argument,
              :or,
              "[#{filter_type}]",
              required: false
            )
          end
        end

        def name_for_base_type(model)
          "Types::#{model}Type"
        end

        def define_base_type(model)
          return if const_defined? name_for_base_type(model)

          klass = Class.new(::Types::BaseObject)
          model.attribute_types.each do |attr, type|
            next if defined?(model.get_restricted_attributes) && model.get_restricted_attributes.include?(attr.to_sym) # add test plz
            klass.send(:field, attr, Hai::GraphQL::TYPE_CAST[type.class] || Hai::GraphQL::TYPE_CAST[type.class.superclass])
          rescue ArgumentError => e
            binding.pry
          end

          ::Types.const_set "#{model}Type", klass
        end

        def add_base_type_reflections(name, ref)
          if name == ref.plural_name
            name_for_base_type(ref.active_record).constantize.send(
              :field,
              name,
              "[#{name_for_base_type(ref.klass)}]"
            )
          else
            name_for_base_type(ref.active_record).constantize.send(
              :field,
              name,
              name_for_base_type(ref.klass)
            )
          end
        rescue NoMethodError => e
          binding.pry
        end

        def define_input_object(model)
          # input objects
          klass = Class.new(::Types::BaseInputObject)
          klass.description("Attributes for creating or updating a #{model}.")
          model.attribute_types.each do |attr, type|
            next if %w[id created_at updated_at].include?(attr)

            klass.argument(
              attr,
              Hai::GraphQL::TYPE_CAST[type.class]|| Hai::GraphQL::TYPE_CAST[type.class.superclass],
              required: false
            )
          end
          ::Types.const_set "#{model}Attributes", klass
        end

        def name_for_filter_type(model)
          "#{model}FilterInputType"
        end

        def define_filter_type(model)
          # Class Filter
          filter_klass = Class.new(::GraphQL::Schema::InputObject)
          model.attribute_types.each do |attr, type|
            filter_klass.send(
              :argument,
              attr,
              AREL_TYPE_CAST[type.class] ||
                AREL_TYPE_CAST[type.class.superclass],
              required: false
            )
          end

          Object.const_set name_for_filter_type(model), filter_klass
        end

        def add_filter_type_reflections(name, ref)
          name_for_filter_type(ref.active_record).constantize.send(
            :argument,
            name,
            name_for_filter_type(ref.klass),
            required: false
          )
        rescue NoMethodError, RuntimeError => e
          binding.pry
        end
      end
    end
  end
end
