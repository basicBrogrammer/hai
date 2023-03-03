module Hai
  class Delete
    attr_reader :model, :context

    def initialize(model, context)
      @model = model
      @context = context
    end

    def execute(id:)
      record = model.find(id)
      raise UnauthorizedError if record.respond_to?(:check_hai_policy) && record.check_hai_policy(:delete, context)

      record.destroy
    end
  end
end
