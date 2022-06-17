# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "yasashii"

require "minitest/autorun"
require "factory_bot"
require "active_record"
require "active_record/fixtures"
require "active_support/test_case"
require "pry"

class Minitest::Test
  include FactoryBot::Syntax::Methods
end
# this was needed to find the defs for somereason?
FactoryBot.find_definitions

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "yasashii_test",
  password: "",
  host: "localhost"
)

load File.dirname(__FILE__) + "/support/schema.rb"
load File.dirname(__FILE__) + "/support/models.rb"
