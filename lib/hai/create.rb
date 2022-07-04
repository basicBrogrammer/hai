module Hai
  class Create
    attr_accessor :model, :context

    def initialize(model, context)
      @model = model
      @context = context
    end

    def execute(**attrs)
      instance = model.new(**attrs)
      instance.run_action_modification(:create, context) if instance.respond_to?(:run_action_modification)
      instance.save
      instance
    end
  end
end
