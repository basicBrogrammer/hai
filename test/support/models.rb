require "hai/action_mods"

class User < ActiveRecord::Base
  include Hai::ActionMods
  has_many :rides

  action(:create) do |user, context|
    user.admin = context == 1
  end
end

class Ride < ActiveRecord::Base
  belongs_to :user
end
