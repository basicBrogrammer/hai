FactoryBot.define do
  factory :ride do
    sequence :title do |n|
      "Ride#{n}"
    end
    user
  end
end
