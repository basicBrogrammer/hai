module Hai
  module ActionMods
    def self.included(base)
      base.extend(ClassMethods)
    end

    def run_action_modification(action, context)
      return unless (action_mod = self.class.action_mods[action])

      action_mod.call(self, context)
    end

    module ClassMethods
      def action_mods
        @action_mods ||= {}
      end

      # TODO: validate CRUD actions
      def action(action, &block)
        action_mods[action] = lambda do |instance, context|
          block.call(instance, context)
        end
      end
    end
  end
end
