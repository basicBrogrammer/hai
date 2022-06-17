class User < ActiveRecord::Base
  has_many :rides
end

class Ride < ActiveRecord::Base
  belongs_to :user
end
