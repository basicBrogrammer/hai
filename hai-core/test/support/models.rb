require "hai/action_mods"

class User < ActiveRecord::Base
  include Hai::ActionMods
  has_many :rides
  has_many :posts
  validates :name, uniqueness: true

  module Actions
    def self.create(user, context)
      user.admin = context == 1
    end
  end

  module Policies
    def self.update(user, context)
      user.name != context[:foo]
    end
  end
end

class Ride < ActiveRecord::Base
  belongs_to :user
end

class Post < ActiveRecord::Base
  belongs_to :user
end
