class Autoscout24 < Crawler
  @name = "autoscout24.nl"
  countries = %w[NL A B D E F I L]
  @start_urls = countries.map do |c|
     "https://www.autoscout24.nl/lst/#{Crawler.make}/#{Crawler.model}?sort=age&desc=1&ustate=N%2CU&size=20&page=1&cy=#{c}&atype=C&ac=0"
  end

  def parse(response, url:, data: {})
    stop_crawling = false
    response.xpath("//div[@class='cl-list-element cl-list-element-gap']").each do |item|
      car = Car.new(crawler: self.class)
      
      a = item.at_xpath("div//div/a[@data-item-name='detail-page-link']") || next
      car.url = absolute_url(a[:href], base: url).split('?').first
      
      car.version = item.xpath("div//h2[contains(@class, 'cldt-summary-version')]").text
      
      car.price   = item.at_xpath("div//span[@data-item-name='price']").text.split(",-").first
            
      car.km      = item.xpath("div//ul/li").first.text
      car.year    = Date.parse(item.xpath("div//ul/li")[1].text.strip) rescue nil
      
      car.country = item.xpath("div//span[contains(@class, '-summary-seller-contact-country')]").text.upcase
      
      stop_crawling = !car.save && Car.where(url: car.url).present?
      break if stop_crawling
    end
    
    if next_page = response.at_xpath("//link[@rel='next']")
      request_to :parse, url: next_page[:href] unless stop_crawling
    end
  end
end
