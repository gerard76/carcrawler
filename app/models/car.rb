class Car < ApplicationRecord
  validates :url,     uniqueness: true
  validates :version, uniqueness: { scope: [:km, :price]}
  validates :year,    presence: true
  validates :price,   presence: true, numericality: { greater_than: 5000 }
  validates :crawler, presence: true
  
  def available?
    if defined? crawler.constantize.available?
      return crawler.constantize.available?(url)
    end
    
    response = HTTParty.head(url)
    response.code == 200
  end
end
