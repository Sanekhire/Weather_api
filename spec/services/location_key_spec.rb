# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationKey do
  subject(:load_to_city) { described_class.load_to_city }

  let(:loc) { create(:location) }
  let(:client_test) { instance_double(described_class) }

  before do
    allow(described_class).to receive(:new).and_return(client_test)
    allow(client_test).to receive(:access_to_site).and_return([{ 'Key' => '100000' }])
  end

  context 'update location with location_key' do
    it {
      loc
      load_to_city
      expect(Location.first.location_key).to eq '100000'
    }
  end
end
