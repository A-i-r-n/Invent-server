module AreaImporter
  def self.import
    json = JSON.parse(File.read(File.join(Rails.root,'db','area.json')))

    json.each do |province_hash|
      province = Area.new(name: province_hash['p'])
      if province.save
        province_hash['c'].each { |city_hash|
          city = Area.new(name:city_hash['n'],parent_id: province.id)
          if city.save && city_hash['a']
            city_hash['a'].each do |street_hash|
              Area.create(name:street_hash['s'],parent_id: city.id)
            end
          end
        }
      end
    end
  end
end
