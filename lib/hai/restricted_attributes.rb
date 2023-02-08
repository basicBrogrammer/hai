module Hai
  module RestrictedAttributes
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def restricted_attributes(*attrs)
        @@restricted_attributes = attrs
      end

      def get_restricted_attributes
        @@restricted_attributes
      end
    end
  end
end
