FactoryBot.define do
  factory :forecast do
    association :location, factory: :location
    date { 1659699284 }
    temp { 10 }
  end
end
