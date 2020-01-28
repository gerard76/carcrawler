class FinnNo < Crawler
  @name = "finn.no"
  @start_urls = [
    "https://www.finn.no/car/used/search.html?rows=1000&make=0.749&model=1.749.2000264&sales_form=1&sort=0"
  ]
  
  def parse(response, url:, data: {})
    response.xpath("//div[@class='ads__unit__content']").each do |item|
      car = Car.new(crawler: self.class, country: 'NO', currency: 'NOK')
      
      a = item.at_xpath("h2/a[@class='ads__unit__link']") || next
      car.url     = absolute_url(a[:href], base: url)
      car.version = a.text
      
      data = item.xpath("p[@class='ads__unit__content__keys']/span")
      
      if data
        car.year  = Date.parse("01/" + data[0].text) rescue nil
        car.km    = data[1]&& data[1].text.gsub(/[^0-9]/,'')
        car.price = data[2] && data[2].text
      end
      
      request_to :parse_car_page, url: car.url if car.save
    end
  end
  
  def parse_car_page(response, url:, data: {})
    if car = Car.find_by(url: url)
      date = response.xpath("//dl/dt[text() = '1. gang registrert']/following-sibling::dd[1]").text
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