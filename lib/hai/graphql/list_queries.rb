require "hai/types/sort_input_type"

module Hai
  module GraphQL
    class ListQueries
      class << self
        def add(query_type, model)
          add_field(query_type, model)
          define_list_method(query_type, model)
        end

        def add_field(query_type, model)
          query_type.field "list_#{model.name.pluralize.downcase}",
                           ["Types::#{model}Type".constantize] do
            query_type.description "List of #{model}."
            argument :filter,
                     "#{model}FilterInputType".constantize,
                     required: false
            argument :limit, ::GraphQL::Types::Int, required: false
            argument :offset, ::GraphQL::Types::Int, required: false
            argument :sort, Types::SortInputType, required: false

            (model.try(:arguments) || []).each do |name, type, kwargs|
              argument(name, type, **kwargs)
            end
          end
        end

        def define_list_method(query_type, model)
          query_type.define_method(
            "list_#{model.name.pluralize.downcase}"
          ) do |**args|
            Hai::Read.new(model, context).list(
              **args.transform_values do |v|
                [Integer, String].include?(v.class) ? v : v.to_h
              end
            )
          end
        end
      end
    end
  end
end
