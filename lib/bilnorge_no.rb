class BilnorgeNo < Crawler
  @start_urls = ["http://bilnorge.no/bruktbil.php?merke=1400&xorderby=prisa&modellid=140023"]
  
  def parse(response, url:, data: {})
    response.xpath("//table[contains(@class, 'bilvisningstabell')]").each do |item|
      car = Car.new(crawler: self.class, country: 'NO', currency: 'NOK')
      
      car.url   = absolute_url(item.css("a").first[:href], base: url)
      car.price = item.css("strong").first.text.gsub(/[^0-9]/,'')
      
      car.version = item.css("span[class=listevisningsheading]").text.sub(/^#{car.make}/, '').strip
      
      year     = item.css("td[class=listevisningsinfo]").first.text
      car.year = Date.parse("#{year}-01-01") rescue nil
      car.km   = item.css("td[class=listevisningsinfo]")[2].text
      
      request_to :parse_car_page, url: car.url if car.save
    end
    
    if next_page = response.css("a[class=GreenLink]").detect { |a| a.text =~ /Neste/ }
      request_to :parse, url: absolute_url(next_page[:href], base: url)
    end
  end
  
  def parse_car_page(response, url:, data: {})
    if car = Car.find_by(url: url)
      date = response.xpath("//tr/td[contains(text(),' 1. gang reg.')]/following-sibling::td[2]").text
      year = Date.parse(date) rescue nil
      car.update(year: year)
    end
  end
end