module Hai
  class Read
    attr_accessor :model
    attr_reader :table, :context

    def initialize(model, context)
      @model = model
      @context = context
      @context[:model] = model
      @table = model.arel_table
    end

    # return [] or ActiveRecord::Relationship
    def list(filter: nil, limit: nil, offset: nil, sort: nil, **extra)
      check_list_policy(context)

      context[:arguments] = extra
      query = build_filter(filter)
      query = query.order({ sort.fetch(:field) => sort.fetch(:order) }) if sort
      query = query.limit(limit) if limit
      query = query.offset(offset) if offset
      run_action_modification(query)
    end

    # return nil or model
    def read(query_hash)
      build_filter(query_hash).first.tap do |record|
        if record.respond_to?(:check_hai_policy) &&
             !record.check_hai_policy(:read, context)
          raise UnauthorizedError
        end
      end
    end

    private

    def check_read_policy
      if model.const_defined?("Policies") && model::Policies.respond_to?(:read)
        model::Policies.read(context)
      else
        true
      end
    end

    def check_list_policy
      if model.const_defined?("Policies") && model::Policies.respond_to?(:list)
        model::Policies.list(context)
      else
        true
      end
    end

    def run_action_modification(query)
      if model.const_defined?("Actions") && model::Actions.respond_to?(:list)
        model::Actions.list(query, context)
      else
        query
      end
    end

    def reflections
      @reflections ||= model.reflections.symbolize_keys
    end

    def query_reflections(query_hash)
      reflections
        .each_with_object({}) do |(ref, _info), acc|
          acc[ref] = query_hash.delete(ref)
        end
        .compact
    end

    def build_reflection_queries(query_hash)
      reflections
        .each_with_object({}) do |(ref, info), acc|
          q_hash = query_hash.delete(ref)
          acc[ref] = info.klass.where(
            where_clause(info.klass.arel_table, q_hash)
          ) if q_hash
        end
        .compact
    end

    def build_joins(filter_hash)
      reflections.map do |ref, _|
        if filter_hash
             .keys
             .concat((filter_hash[:or] || []).flat_map(&:keys).uniq)
             .include?(ref)
          ref
        end
      end
    end

    def build_filter(filter_hash)
      return model.all unless filter_hash.present?

      joins = build_joins(filter_hash)
      reflection_queries = build_reflection_queries(filter_hash)
      or_branch = filter_hash.delete(:or)
      # build_reflection_queries mutates the filter_hash
      query =
        (
          if filter_hash.present?
            model.where(where_clause(model.arel_table, filter_hash))
          else
            model.all
          end
        )

      joins.compact.each { |ref| query = query.left_joins(ref) }
      reflection_queries.each { |_ref, q| query = query.merge(q) }

      return query unless or_branch

      add_sub_query(query, or_branch)
    end

    def add_sub_query(query, or_branch)
      or_branch.each { |q| query = query.or(build_filter(q)) }
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
  end
end
