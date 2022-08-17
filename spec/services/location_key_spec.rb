# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationKey do
  subject(:instance) { described_class.new(Rails.application.credentials.weather_api_key) }
  subject(:load_to_city) { described_class.load_to_city }
  let(:loc) { create(:location, city_name: 'Mariupol') }

  describe '#access_to_site' do
    let(:access_to_site) { instance.access_to_site(city) }
    let(:city) { Location.last }

    context 'when gets responce with weather data' do
      it 'has return correct attributes', :vcr do
        loc
        expect(access_to_site[0].keys).to include('Key')
      end
    end

  end

  describe '#load_to_city' do
    let(:loc) { create(:location) }
    let(:client_test) { instance_double(described_class) }

    before do
      allow(described_class).to receive(:new).and_return(client_test)
      allow(client_test).to receive(:access_to_site).and_return([{ 'Key' => '100000' }])
    end

    context 'when update location with location_key' do
      it 'has return correct key rom record' do
        loc
        load_to_city
        expect(Location.first.location_key).to eq '100000'
      end
    end
  end

  
end
