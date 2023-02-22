require "test_helper"
require "hai/create"

class HaiUpdateTest < Minitest::Test
  def setup
    @subject = Hai::Update.new(User, { foo: "failing context" })
  end

  def test_updates_a_new_record
    user = create(:user)
    original_count = User.count
    name = "Bobby #{SecureRandom.hex}"
    refute_equal name, user.name

    expected = @subject.execute(id: user.id, attributes: { name: name })

    assert_empty expected[:errors]

    result = expected[:result]
    assert_equal original_count, User.count
    assert_equal name, result.name
    assert_equal name, user.reload.name
  end

  def test_returns_errors
    create(:user, name: "bob")
    user = create(:user)

    expected = @subject.execute(id: user.id, attributes: { name: "bob" })

    assert_equal ["Name has already been taken"], expected[:errors]
    assert_nil expected[:results]
  end

  def test_handles_policies
    user = create(:user, name: "failing context")
    expected = @subject.execute(id: user.id, attributes: { name: "bob" })

    assert_equal ["UnauthorizedError"], expected[:errors]
    assert_nil expected[:results]
  end
end
