module Hai
  module Policies
    def self.included(base)
      base.extend(ClassMethods)
    end

    def check_hai_policy(action, context)
      return true unless (policy = self.class.policies[action])

      policy.call(self, context)
    end

    module ClassMethods
      def policies
        @policies ||= {}
      end

      # TODO: validate CRUD actions
      def policy(action, &block)
        policies[action] = lambda do |instance, context|
          block.call(instance, context)
        end
      end
    end
  end
end
