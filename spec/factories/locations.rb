# frozen_string_literal: true

FactoryBot.define do
    factory :location do
        sequence(:city_name) {|n| "city#{n}"}
    end
end