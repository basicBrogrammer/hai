module Hai
  class Read
    attr_accessor :model
    attr_reader :table, :context

    def initialize(model, context)
      @model = model
      @context = context
      @table = model.arel_table
    end

    # return [] or ActiveRecord::Relationship
    def list(query_hash)
      query = build_filter(query_hash.delete(:filter))
      query = query.limit(query_hash[:limit]) if query_hash[:limit]
      query = query.offset(query_hash[:offset]) if query_hash[:offset]
      query
    end

    # return nil or model
    def read(query_hash)
      model.find_by(build_query(query_hash[:filter])).tap do |record|
        raise UnauthorizedError if record.respond_to?(:check_hai_policy) && !record.check_hai_policy(:read, context)
      end
    end

    private

    # TODO: prolly can remove this
    def select_manager
      @select_manager ||= Arel::SelectManager.new(table)
    end

    def reflections
      @reflections ||= model.reflections.symbolize_keys
    end

    def query_reflections(query_hash)
      reflections.each_with_object({}) do |(ref, _info), acc|
        acc[ref] = query_hash.delete(ref)
      end.compact
    end

    def build_reflection_queries(query_hash)
      reflections.each_with_object({}) do |(ref, info), acc|
        q_hash = query_hash.delete(ref)
        acc[ref] = info.klass.where(where_clause(info.klass.arel_table, q_hash)) if q_hash
      end.compact
    end

    def build_filter(filter_hash)
      return model.all unless filter_hash.present?

      reflection_queries = build_reflection_queries(filter_hash)
      # build_reflection_queries mutates the filter_hash
      query = filter_hash.present? ? model.where(build_query(filter_hash)) : model.all

      reflection_queries.each do |ref, q|
        query = query.joins(ref).merge(q)
      end

      query
    end

    def build_query(query_hash)
      or_branch = query_hash.delete(:or)
      query = where_clause(model.arel_table, query_hash)

      return query unless or_branch

      add_sub_query(query, or_branch)
    end

    def add_sub_query(query, or_branch)
      or_branch.each do |q|
        query = query.or(where_clause(model.arel_table, q))
      end
      query
    end

    def where_clause(table, query_hash)
      query_hash.inject(table) do |acc, (attribute, filter)|
        predicate, value = filter.first
        if acc.is_a?(Arel::Table)
          acc[attribute].send(predicate, value)
        else
          acc.and(table[attribute].send(predicate, value))
        end
      end
    end

    def limit; end

    def offset; end

    def having; end

    def group; end

    def order; end

    def select; end

    def distinct; end
  end
end
