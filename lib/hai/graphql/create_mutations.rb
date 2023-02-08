require "hai/types/base_create"

module Hai
  module GraphQL
    class CreateMutations
      class << self
        def add(mutation_type, model)
          define_resolver(model)
          add_field(mutation_type, model)
        end

        def define_resolver(model)
          klass = Class.new(Hai::GraphQL::Types::BaseCreate)
          klass.send(:graphql_name, "Create#{model}")
          klass.description("Attributes for creating or updating a #{model}.")
          model.attribute_types.each do |attr, type|
            next if %w[id created_at updated_at].include?(attr)
            next if attr.blank? # if the model has no other attributes

            klass.argument(
              attr,
              Hai::GraphQL::TYPE_CAST[type.class] ||
                Hai::GraphQL::TYPE_CAST[type.class.superclass],
              required: false
            )
          end

          klass.field(:result, ::Types.const_get("#{model}Type"))

          klass.define_method(:resolve) do |args = {}|
            Hai::Create.new(model, context).execute(**args)
          end
          Hai::GraphQL::Types.const_set("Create#{model}", klass)
        end

        def add_field(mutation_type, model)
          mutation_type.field(
            "create_#{model.name.downcase}",
            mutation: Hai::GraphQL::Types.const_get("Create#{model}")
          )
        end
      end
    end
  end
end
