require 'rails/generators'
require 'rails/generators/base'

module Hai
  module Install
    class GraphqlGenerator < Rails::Generators::Base
      class_option :nullify_session, type: :boolean, default: false

      def rails_preload
        Rails.application.eager_load!
      end

      def install_graphql_ruby
        generate "graphql:install"
        run "bundle install"
      end

      def nullify_session
        if options[:nullify_session]
          gsub_file 'app/controllers/graphql_controller.rb', '# protect_from_forgery with: :null_session', 'protect_from_forgery with: :null_session'
        end
      end

      def add_types
        hai_types = "hay_types(#{model_names.join(', ')})"
        inject_into_file "app/graphql/#{app_name.underscore}_schema.rb", after: "class #{app_name}Schema < GraphQL::Schema" do <<~RUBY.indent(2)

          include Hai::GraphQL::Types
          hai_types(#{model_names.join(', ')})
        RUBY
        end
      end

      def add_queries
        inject_into_file "app/graphql/types/query_type.rb", after: "include GraphQL::Types::Relay::HasNodesField" do <<~RUBY.indent(4)

          include Hai::GraphQL
          hai_query(#{model_names.join(', ')})
        RUBY
        end
      end

      def add_mutations
        inject_into_file "app/graphql/types/mutation_type.rb", after: "class MutationType < Types::BaseObject" do <<~RUBY.indent(4)

          include Hai::GraphQL
          hai_mutation(#{model_names.join(', ')})
        RUBY
        end
      end

      private

      def model_names
        ApplicationRecord.descendants.map(&:name)
      end

      def app_name
        require File.expand_path("config/application", destination_root)
        if Rails.application.class.respond_to?(:module_parent_name)
          Rails.application.class.module_parent_name
        else
          Rails.application.class.parent_name
        end
      end
    end
  end
end
