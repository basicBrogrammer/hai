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
      raise UnauthorizedError if record.respond_to?(:check_hai_policy) && !record.check_hai_policy(:update, context)

      record.update(**attributes)
      record
    end
  end
end
