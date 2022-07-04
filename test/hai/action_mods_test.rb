require "test_helper"
require "hai/action_mods"

module Hai
  class ActionModsTest < Minitest::Test
    class Foo
      include Hai::ActionMods
      attr_accessor :is_bar

      action(:bar) do |instance, context|
        instance.is_bar = context == "bar"
      end
    end

    class Fizz
      include Hai::ActionMods
      attr_accessor :is_buzz

      action(:buzz) do |instance, context|
        instance.is_buzz = context == "buzz"
      end
    end

    def test_adds_a_action_mods
      foo = Foo.new
      fizz = Fizz.new
      assert_nil foo.is_bar
      assert_nil fizz.is_buzz

      foo.run_action_modification(:bar, "bar")
      assert_equal true, foo.is_bar

      foo.run_action_modification(:bar, "buzz")
      assert_equal false, foo.is_bar
    end

    def test_action_mods_do_not_bleed_to_other_classes
      refute Fizz.action_mods.keys == Foo.action_mods.keys
    end

    def test_gracefully_continues_if_no_action_mod_set
      assert_nil Foo.new.run_action_modification(:not_an_action, 1)
    end
  end
end
