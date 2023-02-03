require "hai"
require "rails"

module Hai
  class Railtie < Rails::Railtie
    railtie_name :hai

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
