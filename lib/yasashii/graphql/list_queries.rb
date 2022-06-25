module Yasashii
  module GraphQL
    class ListQueries
      class << self
        def add(query_type, model)
          define_filter_type(model)
          add_field(query_type, model)
          define_list_method(query_type, model)
        end

        def define_filter_type(model)
          filter_klass = Class.new(::GraphQL::Schema::InputObject)
          model.attribute_types.each do |attr, type|
            filter_klass.send(:argument, attr, AREL_TYPE_CAST[type.class], required: false)
          end
          Object.const_set "#{model}FilterInputType", filter_klass
        end

        def add_field(query_type, model)
          query_type.field "list_#{model.name.downcase}", ["Types::#{model}Type".constantize] do
            query_type.description "List of #{model}."
            argument :filter, "#{model}FilterInputType".constantize, required: false
            argument :limit, ::GraphQL::Types::Int, required: false
            argument :offset, ::GraphQL::Types::Int, required: false
          end
        end

        def define_list_method(query_type, model)
          query_type.define_method("list_#{model.name.downcase}") do |**args|
            Yasashii::Read.new(model).list(args.transform_values { |v| v.is_a?(Integer) ? v : v.to_h })
          end
        end
      end
    end
  end
end
