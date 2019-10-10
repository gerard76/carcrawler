
class Autotrader < Crawler
  price_steps = (10_000..100_000).step(10_000).to_a
  @start_urls = price_steps.map do |priceto|
    pricefrom = priceto - 10_000
    "https://www.autotrader.nl/auto/bmw/i3/?sort=price&desc=1&priceto=#{priceto}&pricefrom=#{pricefrom}"
  end
 
  def parse(response, url:, data: {})
    
    response.xpath("//ul[@class='css-t1vlyw']/li[@class='css-1thwd7b']").each do |item|
      car = Car.new(country: 'NL', make: 'BMW i3')
      
      parsed = URI::parse(absolute_url(item.at_xpath('div/a')[:href], base: url))
      parsed.fragment = parsed.query = nil
      car.url = parsed.to_s
      
      car.version = item.at_xpath('div/a/h2').text.strip.sub(/^BMW i3/, '').strip
      
      car.price   = item.at_xpath("div/a//span[@class='css-18of4ng']").text.gsub(/[^0-9]/,'')
      car.km      = item.xpath("div//span[contains(text(), 'Km-stand')]/b").text.gsub(/[^0-9]/,'')
      
      year        = item.xpath("div//span[contains(text(), 'Bouwjaar')]/b").text
      car.year    = Date.parse(year) rescue nil
      
      car.save
    end
    
    nextpage = response.at_xpath("//a[@class='page-nav-next']")
    request_to :parse, url: absolute_url(nextpage[:href], base: url) if nextpage
  end
end