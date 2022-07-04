module Hai
  class Read
    attr_accessor :model
    attr_reader :table

    def initialize(model)
      @model = model
      @table = model.arel_table
    end

    # return [] or ActiveRecord::Relationship
    def list(query_hash)
      limit = query_hash.delete(:limit)
      offset = query_hash.delete(:offset)
      filter = query_hash.delete(:filter)

      reflection_queries = build_reflection_queries(filter) if filter
      query = filter.present? ? model.where(build_query(filter)) : model.all
      if filter
        reflection_queries.each do |ref, q|
          query = query.joins(ref).merge(q)
        end
      end

      query = query.limit(limit) if limit
      query = query.offset(offset) if offset
      query
    end

    # return nil or model
    def read(query_hash)
      model.find_by(build_query(query_hash))
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
