require "hai/action_mods"

class User < ActiveRecord::Base
  include Hai::ActionMods
  has_many :rides
  has_many :posts

  module Actions
    def self.create(user, context)
      user.admin = context == 1
    end
  end
end

class Ride < ActiveRecord::Base
  belongs_to :user
end

class Post < ActiveRecord::Base
  belongs_to :user
end
