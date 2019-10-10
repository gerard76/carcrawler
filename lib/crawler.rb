class Crawler < Kimurai::Base
  @engine = :selenium_chrome
  @config = {
    user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
    before_request: { delay: 3..6 }
  }
  
  def self.crawl!
    BilwebSe.crawl!
    FinnNo.crawl!
    Autoscout24.crawl!
    Autotrack.crawl!
    Autotrader.crawl!
  end
end
