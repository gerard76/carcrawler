class BroommarkedNo < Crawler
  @name = "broommarked.no"
  @start_urls = ["https://www.broommarked.no/s/search/?type=hmaAuto&sort=published&page=0&b=BMW_i3"]
  
  def parse(response, url:, data: {})
    json = JSON.parse(response)
    stop_crawling = false
    json['data'].each do |item|
      car = Car.new(crawler: self.class, country: 'NO', currency: 'NOK')
      
      car.version = item['title']
      
      car.url   = "https://www.broommarked.no/view/#{item['aditemid']}"
      car.year  = Date.parse("#{item['yearmodel']}-01-01")
      car.km    = item['km']
      car.price = item['price']
      
      stop_crawling = !car.save && Car.where(url: car.url).present?
      break if stop_crawling
    end
    
    unless json['data'].empty?
      current_page = Rack::Utils.parse_query(URI(url).query)['page'].to_i
      request_to :parse, url: url.gsub("page=#{current_page}", "page=#{current_page + 1}") unless stop_crawling
    end
  end
end