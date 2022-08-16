# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:loc) { create(:location) }

    it "has to be valid" do
      expect(loc).to be_valid
    end

  context "not valid" do
    it "has not to be valid by length" do
      loc.city_name = 'c'
      expect(loc).not_to be_valid
    end

    it "has not to be valid by presence" do
      loc.city_name = ''
      expect(loc).not_to be_valid
    end

    
    it "has not to be valid by unique" do
      create(:location, city_name: 'city')
      loc2 = build(:location, city_name: 'city')
      expect(loc2.save).to eq false
    end
  end


    it "can`t save more than 10 locations" do
      create_list(:location, 10)
      loc_f = build(:location)
      expect(loc_f.save).to  eq false
    end
  


  
end
