# frozen_string_literal: true

require "test_helper"

class TestYasashii < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Hai::VERSION
  end

  def test_it_does_something_useful
    create(:user)
    assert User.count > 0
  end
end
