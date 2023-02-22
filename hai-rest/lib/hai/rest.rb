# frozen_string_literal: true

require_relative "rest/version"

if defined?(Rails)
  require "generators/install"
end

module Hai
  module Rest
    class Error < StandardError; end

    class Engine < ::Rails::Engine
      isolate_namespace Hai
    end
  end
end
