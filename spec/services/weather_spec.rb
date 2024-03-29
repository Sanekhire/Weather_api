# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Weather do
  describe '#get_forecast' do
    subject(:instance) { described_class.new(Rails.application.credentials.weather_api_key) }

    let(:city) { Location.first }
    let(:forecast) { instance.get_forecast(city) }

    before { create(:location, city_name: 'Mariupol', location_key: '323037') }

    context 'when gets responce with weather data' do
      it 'has return correct attributes', :vcr do
        expect(forecast[0].keys).to include('EpochTime', 'Temperature')
      end
    end
  end

  describe '#load_data' do
    subject(:load_data) { described_class.load_data }

    let(:access_test) { instance_double(described_class) }

    before do
      create(:location, city_name: 'test_city', location_key: 'test_key')
      allow(described_class).to receive(:new).and_return(access_test)
      allow(access_test).to receive(:get_forecast).and_return([{ 'EpochTime' => 1660635817,
                                                                 'Temperature' => { 'Metric' => { 'Value' => 30.0 } } }])
    end

    context 'with correct data from weather api' do
      it 'creates a new record in DB with correct attributes' do
        load_data
        expect(Forecast.count).to eq(1)
        expect(Forecast.last).to have_attributes(date: 1660635817, temp: 30.0)
      end
    end

    context 'when client returns correct data with the same datetime' do
      before { create(:forecast, date: 1660635817, temp: 8.0, location_id: 1) }

      it 'does not duplicate records' do
        expect { load_data }.not_to change(Forecast, :count).from(1)
      end
    end
  end
end
