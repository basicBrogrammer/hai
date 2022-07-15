module Hai
  class Update
    class UnauthorizedError < StandardError; end
    attr_reader :model, :context

    def initialize(model, context)
      @model = model
      @context = context
    end

    def execute(id:, attributes:)
      record = model.find(id)
      if record.respond_to?(:check_hai_policy) && !record.check_hai_policy(
        :update, context
      )
        return { errors: ["UnauthorizedError"],
                 result: nil }
      end

      if record.update(**attributes)
        { errors: [], result: record }
      else
        { errors: record.errors.map(&:full_message), result: nil }
      end
    end
  end
end
