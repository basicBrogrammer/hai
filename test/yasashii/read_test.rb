require "test_helper"

class YasashiiReadTest < Minitest::Test
  def test_read_finds_a_single_record
    assert_equal users(:one), Yasashii::Read.new(User).read({ id: { eq: users(:one).id } })
    assert_nil Yasashii::Read.new(User).read({ id: { eq: 1 } })
  end

  def test_list_basic_query
    assert_equal [users(:one)], Yasashii::Read.new(User).list({ name: { eq: "MyStringone" } })
    assert_equal [users(:one), users(:two)],
                 Yasashii::Read.new(User).list({ name: { in: %w[MyStringone MyStringtwo] } })
  end

  def test_list_handles_or_queries
    assert_equal [users(:one), users(:three)],
                 Yasashii::Read.new(User).list({ name: { eq: "MyStringone" }, or: { name: { eq: "MyStringthree" } } })
  end

  def test_list_handles_query_with_limit
    assert_equal User.all.limit(5),
                 Yasashii::Read.new(User).list(limit: 5)
    assert_equal User.all.limit(7),
                 Yasashii::Read.new(User).list(limit: 7)
  end

  def test_list_handles_query_with_offset
    assert_equal User.all.offset(2),
                 Yasashii::Read.new(User).list(offset: 2)
  end

  def test_list_handles_query_with_limit_and_offset
    assert_equal User.all.limit(4).offset(2),
                 Yasashii::Read.new(User).list(offset: 2, limit: 4)
  end

  def test_list_handles_multiple_ors
    assert_equal [users(:one), users(:four), users(:nine)],
                 Yasashii::Read.new(User).list(name: { eq: "MyStringone" },
                                               or: {
                                                 name: { eq: "MyStringfour" }, or: { name: { eq: "MyStringnine" } }
                                               })
  end

  def test_list_handles_has_many_relationships
    assert_equal [users(:one)],
                 Yasashii::Read.new(User).list(rides: { title: { eq: "RideOne" } })
    assert_equal [users(:two)],
                 Yasashii::Read.new(User).list(rides: { title: { eq: "RideThree" } })
    assert_equal [], Yasashii::Read.new(User).list(rides: { title: { eq: "RideNineAndThreeQuarters" } })
  end
end
