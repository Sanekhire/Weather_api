# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForecastsController, type: :request do
  before do
    create(:location, city_name: 'City1') do |location|
      create(:forecast, date: 1660737448, temp: 30, location: location)
      create(:forecast, date: 1660733934, temp: 18, location: location)
      create(:forecast, date: 1660730285, temp: 2, location: location)
      create_list(:forecast, 24, location: location)
    end
  end

  describe 'GET /locations/city1/weather/current' do
    it 'returns current temp for city1' do
      get '/locations/city1/weather/current'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([{ 'date' => 1660737448, 'temp' => 30.0 }])
    end
  end

  describe 'GET /locations/city1/weather/historical' do
    it 'returns historical temp for city1' do
      get '/locations/city1/weather/historical'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /locations/city1/weather/historical/max' do
    it 'returns max temp for city1' do
      get '/locations/city1/weather/historical/max'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([{ 'date' => 1660737448, 'max' => 30.0 }])
    end
  end

  describe 'GET /locations/city1/weather/historical/min' do
    it 'returns min temp for city1' do
      get '/locations/city1/weather/historical/min'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([{ 'date' => 1660730285, 'min' => 2.0 }])
    end
  end

  describe 'GET /locations/city1/weather/historical/avg' do
    it 'returns avg temp for city1' do
      get '/locations/city1/weather/historical/avg'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([{ 'avg' => 10.8 }])
    end
  end

  describe 'GET /locations/city1/weather/by_time' do
    it 'returns temperature for time closest to input' do
      get '/locations/city1/weather/by_time?timestamp=1660735548'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([{ 'date' => 1660733934, 'temp' => 18.0 }])
    end

    it 'returns 404 when input is empty' do
      get '/locations/city1/weather/by_time?timestamp='
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 when input is over the records' do
      get '/locations/city1/weather/by_time?timestamp=1660741048'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /health' do
    it 'returns status code 200' do
      get '/health'
      expect(response).to have_http_status(:ok)
    end
  end
end
