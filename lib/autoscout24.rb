
class Autoscout24 < Crawler
  base = "https://www.autoscout24.nl"
  countries = %w[NL A B D E F I L]
  @start_urls = countries.map do |c|
    "#{base}/lst/bmw/i3?sort=price&desc=0&fuel=E&ustate=N%2CU&size=20&page=1&cy=#{c}&atype=C&ac=0&"
  end

  def parse(response, url:, data: {})
    
    response.xpath("//div[@class='cl-list-element cl-list-element-gap']").each do |item|
      car = Car.new
      
      a = item.at_xpath("div//div/a[@data-item-name='detail-page-link']")
      car.url     = absolute_url(a[:href], base: url)
      
      car.make    = item.xpath("div//h2[contains(@class, 'cldt-summary-makemodel')]").text
      car.version = item.xpath("div//h2[contains(@class, 'cldt-summary-version')]").text
      
      car.price   =  item.at_xpath("div//span[@data-item-name='price']").text.split(",-").first.gsub(/[^0-9]/,'')
      car.km      = item.xpath("div//ul/li").first.text.gsub(/[^0-9]/,'')
      car.year    = Date.parse(item.xpath("div//ul/li")[1].text.strip) rescue nil
      
      car.country = item.xpath("div//span[contains(@class, '-summary-seller-contact-country')]").text.upcase
      
      car.save
    end
    
    if next_page = response.at_xpath("//link[@rel='next']")
      request_to :parse, url: next_page[:href] if next_page
    end
  end
end