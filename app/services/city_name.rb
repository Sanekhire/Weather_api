# frozen_string_literal: true

class CityName
  def self.load_from_file(file_path)
    file = File.open(file_path) if File.exist?(file_path)
    cities = file.readlines.map(&:chomp)
    file.close

    cities.each do |city|
      Location.create_or_find_by(city_name: city)
    end
  end

  def self.load_from_site
    doc = Nokogiri::HTML(URI.open('https://pastebin.com/raw/dbtemx5F'))
    full_text = doc.css('body').text
    cities = full_text.scan(/City Name = .(.*?),/)
    cities.flatten!
    cities.each do |city|
      Location.create_or_find_by(city_name: city)
    end
  end

  def self.load_default
    cities = ['Mariupol', 'Moscow', 'Nizhniy Novgorod', 'Taganrog', 'Rostov-Na-Donu', 'Orel', 'Donetsk']
    cities.each do |city|
      Location.create_or_find_by(city_name: city)
    end
  end
end
