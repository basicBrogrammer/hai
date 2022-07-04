require "test_helper"
require "hai/create"

class HaiCreateTest < Minitest::Test
  def test_creates_a_new_record
    original_count = User.count
    result = Hai::Create.new(User, nil).execute(name: "bobby")
    assert_equal original_count + 1, User.count
    assert_equal result.name, "bobby"
  end

  def test_allows_for_action_modification_before_save
    result = Hai::Create.new(User, 1).execute(name: "bobby")
    assert_equal "bobby", result.name
    assert result.admin?

    result = Hai::Create.new(User, 2).execute(name: "tommy")
    assert_equal "tommy", result.name
    refute result.admin?
  end

  def test_gracefully_handles_no_action_mods
    original_count = Ride.count
    result = Hai::Create.new(Ride, nil).execute(title: "thing ride")
    assert_equal original_count + 1, Ride.count
    assert_equal result.title, "thing ride"
  end
end
