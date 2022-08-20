# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationsController, type: :request do
  describe 'GET root' do
    let(:loc) { create(:location, city_name: 'City1') }

    it 'returns created cities' do
      loc
      get '/'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([{ 'city_name' => 'City1' }])
    end
  end
end
