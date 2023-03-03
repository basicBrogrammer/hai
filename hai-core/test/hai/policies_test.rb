require "test_helper"
require "hai/policies"

class HaiPoliciesTest < Minitest::Test
  class Foo
    include Hai::Policies

    policy(:boo) do |instance, context|
      instance.is_a?(self) && context == 1
    end
  end

  class Boo
    include Hai::Policies

    policy(:fizz) do |instance, context|
      instance.is_a?(self) && context == 2
    end
  end

  def test_adds_a_policy_action
    assert Foo.new.check_hai_policy(:boo, 1)
    refute Foo.new.check_hai_policy(:boo, 2)
    assert Boo.new.check_hai_policy(:fizz, 2)
    refute Boo.new.check_hai_policy(:fizz, 1)
  end

  def test_policies_do_not_bleed_to_other_classes
    refute Boo.policies.keys == Foo.policies.keys
  end

  def test_gracefully_continues_if_no_policy_set
    assert Foo.new.check_hai_policy(:not_an_action, 1)
  end
end
