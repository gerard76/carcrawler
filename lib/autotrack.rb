
class Autotrack < Crawler
  @start_urls = [ "https://www.autotrack.nl/tweedehands?merkIds=1a67a3d8-178b-43ee-9071-9ae7f19b316a&modelIds.1a67a3d8-178b-43ee-9071-9ae7f19b316a=e2df3c6d-6dc9-48fb-bcbe-f66a9917c471&at-switch=on&policy=accepted-20190101&&paginagrootte=90&paginanummer=1"
   ]

  def parse(response, url:, data: {})
    
    response.xpath("//ul[contains(@class, 'result-list')]/li/article").each do |item|
      car = Car.new(crawler: self.class)
      
      car.url = item.at_xpath('a')[:href]
      
      brand = item.at_xpath("a//meta[@itemprop='brand']")[:content]
      model = item.at_xpath("a//meta[@itemprop='model']")[:content]
      car.make    = "#{brand} #{model}"
      car.version = item.at_xpath("a//meta[@itemprop='description']")[:content]
      
      car.price   = item.at_xpath("a//data[contains(@class, 'result-item__price')]").try(:[],:value)
      
      car.km      = item.at_xpath("a//meta[@itemprop='mileageFromOdometer']")[:content]
      
      year        = item.at_xpath("a//span[@itemprop='productionDate']").text rescue nil
      car.year    = Date.parse("#{year}-01-01") rescue nil
      
      request_to :parse_car_page, url: car.url if car.save
    end
    
    if response.at_xpath("//li[@class='pagination__next']/a").present?
      page = url.split('paginanummer=').last.to_i
      request_to :parse, url: url.gsub(/paginanummer=([0-9]+)/, "paginanummer=#{page + 1}")
    end
  end
  
  def parse_car_page(response, url:, data: {})
    if car = Car.find_by(url: url)
      date = response.xpath("//dt[text() = 'Datum eerste toelating']/following-sibling::dd[1]").text
      # translate dutch to ernglish so Date.parse can do it's magic
      I18n.with_locale(:nl) { I18n.t("date.month_names")}.compact.each_with_index do |month, index|
        date.gsub!(month, I18n.with_locale(:en) { I18n.t("date.month_names")}.compact[index] )
      end
      year = Date.parse(date) rescue nil
      car.update(year: year)
    end
  end
  
  def self.refresh
    cars.each do |car|
      car.delete unless HTTParty.head(car.url).code == 200
    end
  end
end