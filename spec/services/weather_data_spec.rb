# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherData do
  subject(:load_data) { described_class.load_data('test_city') }

  let(:loc) { create(:location, city_name: 'test_city', location_key: 'test_key') }
  let(:access_test) { instance_double(described_class) }

  before do
    allow(described_class).to receive(:new).and_return(access_test)
    allow(access_test).to receive(:get_forecast).and_return([{ 'EpochTime' => 1660635817,
                                                               'Temperature' => { 'Metric' => { 'Value' => 30.0 } } }])
    allow(access_test).to receive_message_chain(:city_loc, :id) { 1 }
  end

  context 'test with correct data from weather api' do
    it {
      loc
      load_data
      expect(Forecast.count).to eq(1)
      expect(Forecast.last).to have_attributes(date: 1660635817, temp: 30.0)
    }
  end
end
