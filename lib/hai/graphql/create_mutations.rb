module Hai
  module GraphQL
    class CreateMutations
      class << self
        def add(mutation_type, model)
          add_field(mutation_type, model)
          define_create_method(mutation_type, model)
        end

        def add_field(mutation_type, model)
          mutation_type.field("create_#{model.name.downcase}", "Types::#{model}Type".constantize) do
            mutation_type.description("Create a #{model}.")
            argument(:attributes, "Types::#{model}Attributes")
          end
        end

        def define_create_method(mutation_type, model)
          mutation_type.define_method("create_#{model.name.downcase}") do |attributes:|
            Hai::Create.new(model).execute(**attributes.to_h)
          end
        end
      end
    end
  end
end
