class BroommarkedNo < Crawler
  @start_urls = ["https://www.broommarked.no/s/search/?type=hmaAuto&sort=price-asc&page=0&b=BMW_i3"]
  
  def parse(response, url:, data: {})
    json = JSON.parse(response)
    json['data'].each do |item|
      car = Car.new(crawler: self.class, country: 'NO')
      
      car.make    = "#{item['brand']} #{item['model']}"
      car.version = item['title']
      
      car.url   = "https://www.broommarked.no/view/#{item['aditemid']}"
      car.year  = Date.parse("#{item['yearmodel']}-01-01")
      car.km    = item['km']
      car.price = (item['price'] / 10.0132423).round
      
      car.save
    end
    
    unless json['data'].empty?
      current_page = Rack::Utils.parse_query(URI(url).query)['page'].to_i
      request_to :parse, url: url.gsub("page=#{current_page}", "page=#{current_page + 1}")
    end
  end
end