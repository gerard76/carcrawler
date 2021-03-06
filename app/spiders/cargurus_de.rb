class CargurusDe < Crawler
  @name = "cargurus.de"
  @base_url = "https://www.cargurus.de/Cars/inventorylisting"
  @start_urls = [
    "#{@base_url}/ajaxFetchSubsetInventoryListing.action?entitySelectingHelper.selectedEntity=d2878"
  ]
  
  def parse(response, url:, data: {})
    json = JSON.parse(response)
    json['listings'].each do |item|
      car = Car.new(crawler: self.class, country: 'DE')
      
      base_url = CargurusDe.instance_variable_get :@base_url
      car.url = "#{base_url}/viewDetailsFilterViewInventoryListing.action?#listing=#{item['id']}"
      
      car.version = item['EXT_MODEL']
      
      car.year  = Date.parse(item['REGISTRATION_DATE'])
      car.km    = item['mileage']
      car.price = item['price'].to_s.split(".").first
      
      car.save
    end
  end
end
