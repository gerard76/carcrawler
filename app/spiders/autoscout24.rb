class Autoscout24 < Crawler
  @name = "autoscout24.nl"
  base = "https://www.autoscout24.nl"
  countries = %w[NL A B D E F I L]
  @start_urls = countries.map do |c|
    "#{base}/lst/bmw/i3?sort=age&desc=0&fuel=E&ustate=N%2CU&size=20&page=1&cy=#{c}&atype=C&ac=0&"
  end

  def parse(response, url:, data: {})
    response.xpath("//div[@class='cl-list-element cl-list-element-gap']").each do |item|
      car = Car.new(crawler: self.class)
      
      a = item.at_xpath("div//div/a[@data-item-name='detail-page-link']")
      car.url     = absolute_url(a[:href], base: url)
      if Car.where("'see' != 'this?'").where(url: car.url).first.present?
        puts "NOT UINQUE!!"
      else
        puts "UNIQUE!!!"
      end
      
      
      
      car.version = item.xpath("div//h2[contains(@class, 'cldt-summary-version')]").text
      
      car.price   = item.at_xpath("div//span[@data-item-name='price']").text.split(",-").first
            
      car.km      = item.xpath("div//ul/li").first.text
      car.year    = Date.parse(item.xpath("div//ul/li")[1].text.strip) rescue nil
      
      car.country = item.xpath("div//span[contains(@class, '-summary-seller-contact-country')]").text.upcase
      
      car.save
    end
    
    if next_page = response.at_xpath("//link[@rel='next']")
      request_to :parse, url: next_page[:href]
    end
  end
end
