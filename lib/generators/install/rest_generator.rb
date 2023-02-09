require 'rails/generators'
require 'rails/generators/base'

module Hai
  module Install
    class RestGenerator < Rails::Generators::Base
      def mount_engine
        route <<-RUBY
          mount Hai::Rest::Engine => "/rest"
        RUBY
      end
    end
  end
end
