# frozen_string_literal: true

FactoryBot.define do
  factory :forecast do
    association :location, factory: :location
    date { 1_659_699_284 }
    temp { 10 }
  end
end
