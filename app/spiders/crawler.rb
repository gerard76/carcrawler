class Crawler < Kimurai::Base
  @engine = :selenium_chrome
  @config = {
    user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
    before_request: { delay: 3..6 }
  }
  
  @make  = 'BMW'
  @model = 'i3'
  
  def self.make
    @make
  end
  
  def self.model
    @model
  end
  
  def self.crawl
    Kimurai.list.values.each { |crawler| crawler.crawl! }
  end
  
  def self.refresh
    Kimurai.list.values.each do |crawler|
      crawler.refresh!
    end
  end
  
  def self.cars
    Car.where(crawler: self.to_s)
  end
  
  def self.refresh!
    cars.delete_all
    crawl!
  end
end
