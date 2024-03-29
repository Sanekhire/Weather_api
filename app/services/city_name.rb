# frozen_string_literal: true

class CityName
  def self.load_data(source = '')
    if source == 'site'
      (cities = new.send(:values_from_site))
    else
      (cities = ['Mariupol', 'Moscow', 'Nizhniy Novgorod', 'Taganrog', 'Rostov-Na-Donu', 'Orel', 'Donetsk'])
    end

    cities.each { |city| Location.create(city_name: city) }
  end

  private

  def values_from_site
    doc = Nokogiri::HTML(URI.open('https://pastebin.com/raw/dbtemx5F'))
    full_text = doc.css('body').text
    cities = full_text.scan(/City Name = .(.*?),/)
    cities.flatten!
  end
end
