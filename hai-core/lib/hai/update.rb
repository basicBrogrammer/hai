module Hai
  class Update
    attr_reader :model, :context

    def initialize(model, context)
      @model = model
      @context = context
    end

    def execute(id:, attributes:)
      record = model.find(id)
      return unauthorized_error unless check_policy(record)

      if record.update(**attributes)
        { errors: [], result: record }
      else
        { errors: record.errors.map(&:full_message), result: nil }
      end
    end

    private

    def unauthorized_error
      { errors: ["UnauthorizedError"], result: nil }
    end

    def check_policy(instance)
      if model.const_defined?("Policies") && model::Policies.respond_to?(:update)
        model::Policies.update(instance, context)
      else
        true
      end
    end
  end
end
