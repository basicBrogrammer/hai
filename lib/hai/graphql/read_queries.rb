module Hai
  module GraphQL
    class ReadQueries
      class << self
        def add(query_type, model)
          add_field(query_type, model)
          define_read_method(query_type, model)
        end

        def add_field(query_type, model)
          query_type.field("read_#{model.name.downcase}", "Types::#{model}Type".constantize) do
            query_type.description("List a single #{model}.")
            model.attribute_types.each do |attr, type|
              argument(attr, Hai::GraphQL::AREL_TYPE_CAST[type.class], required: false)
            end
          end
        end

        def define_read_method(query_type, model)
          query_type.define_method("read_#{model.name.downcase}") do |**args|
            Hai::Read.new(model, context).read(args.transform_values(&:to_h))
          end
        end
      end
    end
  end
end
