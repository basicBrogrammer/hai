module Hai
  module GraphQL
    class UpdateMutations
      class << self
        def add(mutation_type, model)
          define_resolver(model)
          add_field(mutation_type, model)
        end

        def define_resolver(model)
          klass = Class.new(Hai::GraphQL::Types::BaseCreate)
          klass.send(:graphql_name, "Update#{model}")
          klass.description("Mutation to Update #{model}.")

          klass.argument(:attributes, "Types::#{model}Attributes")
          klass.argument(:id, ::GraphQL::Types::ID)

          klass.field(:result, ::Types.const_get("#{model}Type"))

          klass.define_method(:resolve) do |id:, attributes:|
            Hai::Update.new(model, context).execute(id: id, attributes: attributes.to_h)
          end

          Hai::GraphQL::Types.const_set("Update#{model}", klass)
        end

        def add_field(mutation_type, model)
          mutation_type.field("update_#{model.name.downcase}",
                              mutation: Hai::GraphQL::Types.const_get("Update#{model}"))
        end
      end
    end
  end
end
