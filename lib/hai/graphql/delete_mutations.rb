module Hai
  module GraphQL
    class DeleteMutations
      class << self
        def add(mutation_type, model)
          add_field(mutation_type, model)
          define_create_method(mutation_type, model)
        end

        def add_field(mutation_type, model)
          mutation_type.field("delete_#{model.name.downcase}", "Types::#{model}Type".constantize) do
            mutation_type.description("Delete a #{model}.")
            argument(:id, ::GraphQL::Types::ID)
          end
        end

        def define_create_method(mutation_type, model)
          mutation_type.define_method("delete_#{model.name.downcase}") do |id:|
            Hai::Delete.new(model).execute(id: id)
          end
        end
      end
    end
  end
end
