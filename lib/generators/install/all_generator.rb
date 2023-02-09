require 'rails/generators'
require 'rails/generators/base'

module Hai
  module Install
    class AllGenerator < Rails::Generators::Base
      class_option :nullify_session, type: :boolean, default: false

      def install_graphql
        generate "hai:install:graphql", build_options_string
      end

      def install_rest
        generate "hai:install:rest"
      end

      private

      def build_options_string
        options_string = ""
        options_string << ("--nullify_session") if options[:nullify_session]
        options_string
      end
    end
  end
end
