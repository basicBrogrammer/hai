
module Hai
  module GraphQL
    class UpdateMutations
      class << self
        def add(mutation_type, model)
          add_field(mutation_type, model)
          define_create_method(mutation_type, model)
        end

        def add_field(mutation_type, model)
          mutation_type.field("update_#{model.name.downcase}", "Types::#{model}Type".constantize) do
            mutation_type.description("Update a #{model}.")
            argument(:attributes, "Types::#{model}Attributes")
            argument(:id, ::GraphQL::Types::ID)
          end
        end

        def define_create_method(mutation_type, model)
          mutation_type.define_method("update_#{model.name.downcase}") do |id:, attributes:|
            Hai::Update.new(model).execute(id: id, attributes: attributes)
          end
        end
      end
    end
  end
end
