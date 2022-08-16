# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Forecast, type: :model do
  let(:weather) {create(:forecast)}

  context 'when object is valid' do
    it {expect(weather).to be_valid}
  end

  context 'when object is not valid' do
    it { weather.date = '' 
      expect(weather).not_to be_valid}
  
    it { weather.temp = '' 
      expect(weather).not_to be_valid}
  end
end
