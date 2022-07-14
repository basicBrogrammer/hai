module Hai
  class Create
    attr_accessor :model, :context

    def initialize(model, context)
      @model = model
      @context = context
    end

    def execute(**attrs)
      instance = model.new(**attrs)
      run_action_modification(instance)
      if instance.save
        { errors: [], result: instance }
      else
        { errors: instance.errors.map(&:full_message), result: nil }
      end
    end

    def run_action_modification(instance)
      if model.const_defined?("Actions") && model::Actions.respond_to?(:create)
        model::Actions.create(instance, context)
      else
        instance
      end
    end
  end
end
