require "test_helper"
require "hai/create"

class HaiCreateTest < Minitest::Test
  def test_creates_a_new_record
    original_count = User.count
    name = "Bobby #{SecureRandom.hex}"
    expected = Hai::Create.new(User, nil).execute(name: name)
    assert_empty expected[:errors]
    result = expected[:result]
    assert_equal original_count + 1, User.count
    assert_equal name, result.name
  end

  def test_allows_for_action_modification_before_save
    name = "Bobby #{SecureRandom.hex}"
    expected = Hai::Create.new(User, 1).execute(name: name)
    assert_empty expected[:errors]
    result = expected[:result]
    assert_equal name, result.name
    assert result.admin?

    expected = Hai::Create.new(User, 2).execute(name: "tommy")
    assert expected[:errors].empty?
    result = expected[:result]
    assert_equal "tommy", result.name
    refute result.admin?
  end

  def test_gracefully_handles_no_action_mods
    original_count = Ride.count
    expected = Hai::Create.new(Ride, nil).execute(title: "thing ride")
    assert expected[:errors].empty?
    result = expected[:result]
    assert_equal original_count + 1, Ride.count
    assert_equal result.title, "thing ride"
  end

  def test_can_upsert_if_id_is_available
    ride = create(:ride)
    original_count = Ride.count
    refute_equal "thing ride", ride.title
    expected = Hai::Create.new(Ride, {}).execute(id: ride.id, title: "thing ride")
    assert_equal original_count, Ride.count
    refute_equal "thing ride", ride.title
    assert_equal "thing ride", ride.reload.title
  end
end
