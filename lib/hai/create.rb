module Hai
  class Create
    attr_accessor :model, :context

    def initialize(model, context)
      @model = model
      @context = context
    end

    def execute(**attrs)
      id = attrs.delete(:id)
      instance = id ? model.find(id) : model.new

      return unauthorized_error unless check_policy(instance)

      instance.assign_attributes(**attrs)

      run_action_modification(instance)

      if instance.save
        { errors: [], result: instance }
      else
        { errors: instance.errors.map(&:full_message), result: nil }
      end
    end

    private

    def unauthorized_error
      { errors: ["UnauthorizedError"], result: nil }
    end

    def check_policy(instance)
      if model.const_defined?("Policies") &&
           model::Policies.respond_to?(:create)
        model::Policies.create(instance, context)
      else
        true
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
