class BilwebSe < Crawler
  @name = "bilweb.se"
  @start_urls = [
    "https://bilweb.se/sok/bmw/i3?type=1&limit=300",
    "https://bilweb.se/sok/bmw/i3?type=1&limit=300&offset=100"
  ]
  
  def parse(response, url:, data: {})
    response.xpath("//div[contains(@class,'Card-content')]").each do |item|
      car = Car.new(crawler: self.class, country: 'SE', currency: 'SEK')
      
      a = item.at_xpath("h3/a[@class='go_to_detail']") || next
      car.url     = a[:href]
      car.version = a.text
      
      price = item.at_xpath("div/p[@class='Card-mainPrice']") || next
      car.price = item.at_xpath("div/p[@class='Card-mainPrice']").text
      
      data = item.xpath("dl[@class='Card-carData']/dd")
      car.km   = data[0].text
      car.year = Date.parse("01/" + data[1].text) rescue nil
      
      request_to :parse_car_page, url: car.url if car.save
    end
  end
  
  def parse_car_page(response, url:, data: {})
    if car = Car.find_by(url: url)
      date = response.xpath("//li/h5[text() = '1:a regdatum']/following-sibling::p[1]").text.strip
      year = Date.parse(date) rescue nil
      car.update(year: year)
    end
  end
  
  def self.refresh!
    cars.each do |car|
      print "Validating #{car.url}..."
      if car.available?
        puts "ok"
      else
        puts "deleting"
        car.delete
      end 
      sleep(rand(1..2))
    end
    
    crawl!
  end
end