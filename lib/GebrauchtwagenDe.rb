class GebrauchtwagenDe < Crawler
  # searches: mobile.de, hey.car, instamotion, pkw.de, verivox.de
  @start_urls = [
"https://www.12gebrauchtwagen.de/suchen?s[sort]=0&s[mk]=11&s[md]=1017&s[pr_min]=5000&s[zip]=34127&s[rad]=300&s[providers][]=16&s[providers][]=17&s[providers][]=2&s[providers][]=6&s[providers][]=13"
  ]
  
  def parse(response, url:, data: {})
    response.xpath("//div[contains(@class, 'result-slot')]").each do |item|
      car = Car.new(crawler: self.class, country: 'DE')

      a       = item.at_xpath("a[contains(@class,'click-out-')]")
      car.url = absolute_url(a[:href].split("?").first, base: url)

      car.version = item.at_xpath("a/div/h3").text

      car.price = item.at_xpath("a//span[@class='ad-price']").text
      year      = item.at_xpath("a//span[@class='ad-registration-date']").text.sub(/^EZ /, '')
      car.year  = Date.parse(year) rescue nil

      car.km    = item.at_xpath("a//span[@class='ad-mileage']").text

      car.save
    end
    
    if nextpage = response.at_xpath("//a[text()='weiter ❯']")
      href = CGI.unescape(nextpage[:href])
      request_to :parse, url: absolute_url(href, base: url)
    end
    
  end
end
