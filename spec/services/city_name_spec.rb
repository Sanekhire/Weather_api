# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CityName do
  subject(:load_from_site) { described_class.load_data('site') }

  let(:load_default) { described_class.load_data }
  let(:test_cities) { instance_double(described_class) }

  before do
    allow(described_class).to receive(:new).and_return(test_cities)
    allow(test_cities).to receive(:values_from_site).and_return(
      %w[Aachen1 Aalborg Aalesund Aare Aarhus Aba Abadan Abakan Abbotsford Abeokuta2
         Aberdeen]
    )
  end

  context 'when fill table with data' do
    it 'has to be correct with default load' do
      load_default
      expect(Location.count).to eq 7
      expect(Location.first.city_name).to eq 'Mariupol'
      expect(Location.last.city_name).to eq 'Donetsk'
    end

    it 'has to be correct with load from site' do
      load_from_site
      expect(Location.count).to eq 10
      expect(Location.first.city_name).to eq 'Aachen1'
      expect(Location.last.city_name).to eq 'Abeokuta2'
    end
  end
end
