require "test_helper"
require "hai/read"

class HaiReadTest < Minitest::Test
  def setup
    @users = create_list(:user, 10, created_at: rand(1..10).weeks.ago)
    @ride, = create_list(:ride, 2, user: @users.first)
    @other_user_ride = create(:ride, user: @users.second)
    @subject = Hai::Read.new(User, nil)
  end

  def test_read_finds_a_single_record
    assert_equal @users.first, @subject.read(filter: { id: { eq: @users.first.id } })
    assert_nil @subject.read(filter: { id: { eq: User.last.id + 1 } })
  end

  def test_list_basic_query
    assert_equal [@users.first], @subject.list(filter: { name: { eq: @users.first.name } })
    assert_equal [@users.first, @users.second],
                 @subject.list(filter: { name: { in: [@users.first.name, @users.second.name] } })
  end

  def test_list_handles_or_queries
    assert_equal [@users.first, @users.third],
                 @subject.list(filter: { name: { eq: @users.first.name },
                                         or: [{ name: { eq: @users.third.name } }] })
  end

  def test_list_handles_or_queries_for_reflections
    expected = [@users.first, @users.third]
    actual = @subject.list(filter: {
                             name: { eq: @users.third.name },
                             or: [
                               { rides: { title: { eq: @ride.title } } }
                             ]
                           })
    assert_equal expected, actual
  end

  def test_list_handles_query_with_limit
    assert_equal User.all.limit(5),
                 @subject.list(limit: 5)
    assert_equal User.all.limit(7),
                 @subject.list(limit: 7)
  end

  def test_list_handles_query_with_offset
    assert_equal User.all.offset(2),
                 @subject.list(offset: 2)
  end

  def test_list_handles_query_with_limit_and_offset
    assert_equal User.all.limit(4).offset(2),
                 @subject.list(offset: 2, limit: 4)
  end

  def test_list_handles_multiple_ors
    assert_equal [@users.first, @users[3], @users[8]],
                 @subject.list(
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
                 @subject.list(filter: { rides: { title: { eq: @ride.title } } })
    assert_equal [@users.second],
                 @subject.list(filter: { rides: { title: { eq: @other_user_ride.title } } })
    assert_equal [], @subject.list(filter: { rides: { title: { eq: "RideNineAndThreeQuarters" } } })
  end

  def test_list_handles_sorting
    assert_equal User.order(created_at: :desc),
                 @subject.list(sort: { order: "DESC", field: "created_at" })
    assert_equal User.order(created_at: :asc),
                 @subject.list(sort: { order: "ASC", field: "created_at" })
  end
end
