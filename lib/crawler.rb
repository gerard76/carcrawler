class Crawler < Kimurai::Base
  @engine = :selenium_chrome
  @config = {
    user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
    before_request: { delay: 3..6 }
  }
  
  CRAWLERS = %w[BilnorgeNo BilwebSe FinnNo Autoscout24 Autotrack Autotrader BroommarkedNo CargurusDe]
  
  def self.crawl
    CRAWLERS.each { |crawler| crawler.constantize.crawl! }
  end
  
  def self.refresh
    CRAWLERS.each do |crawler|
      crawler.constantize.refresh!
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
