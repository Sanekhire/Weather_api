# frozen_string_literal: true

class LoadCityName
  def self.city_name_from_file(file_name)
    file_path = "#{Rails.root}/#{file_name}"
    file = File.open(file_path) if File.exist?(file_path)
    cities = file.readlines.map(&:chomp)
    file.close

    cities.each do |city|
      Location.create_or_find_by(city_name: city)
    end
  end

  def self.city_name_from_site; end
end
