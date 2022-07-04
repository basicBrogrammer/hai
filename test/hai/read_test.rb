require "test_helper"
require "hai/read"

class HaiReadTest < Minitest::Test
  def setup
    @users = create_list(:user, 10)
    @ride, = create_list(:ride, 2, user: @users.first)
    @other_user_ride = create(:ride, user: @users.second)
  end

  def test_read_finds_a_single_record
    assert_equal @users.first, Hai::Read.new(User).read({ id: { eq: @users.first.id } })
    assert_nil Hai::Read.new(User).read({ id: { eq: User.last.id + 1 } })
  end

  def test_list_basic_query
    assert_equal [@users.first], Hai::Read.new(User).list(filter: { name: { eq: @users.first.name } })
    assert_equal [@users.first, @users.second],
                 Hai::Read.new(User).list(filter: { name: { in: [@users.first.name, @users.second.name] } })
  end

  def test_list_handles_or_queries
    assert_equal [@users.first, @users.third],
                 Hai::Read.new(User).list(filter: { name: { eq: @users.first.name },
                                                    or: [{ name: { eq: @users.third.name } }] })
  end

  def test_list_handles_query_with_limit
    assert_equal User.all.limit(5),
                 Hai::Read.new(User).list(limit: 5)
    assert_equal User.all.limit(7),
                 Hai::Read.new(User).list(limit: 7)
  end

  def test_list_handles_query_with_offset
    assert_equal User.all.offset(2),
                 Hai::Read.new(User).list(offset: 2)
  end

  def test_list_handles_query_with_limit_and_offset
    assert_equal User.all.limit(4).offset(2),
                 Hai::Read.new(User).list(offset: 2, limit: 4)
  end

  def test_list_handles_multiple_ors
    assert_equal [@users.first, @users[3], @users[8]],
                 Hai::Read.new(User).list(
                   filter: {
                     name: { eq: @users.first.name },
                     or: [
                       { name: { eq: @users[3].name } },
                       { name: { eq: @users[8].name } }
                     ]
                   }
                 )
  end

  def test_list_handles_has_many_relationships
    assert_equal [@users.first],
                 Hai::Read.new(User).list(filter: { rides: { title: { eq: @ride.title } } })
    assert_equal [@users.second],
                 Hai::Read.new(User).list(filter: { rides: { title: { eq: @other_user_ride.title } } })
    assert_equal [], Hai::Read.new(User).list(filter: { rides: { title: { eq: "RideNineAndThreeQuarters" } } })
  end
end
