class Car < ApplicationRecord

  scope :visible, -> { where(visible: true) }
  
  before_validation :set_eur
  
  # Validations
  validates :url,     uniqueness: true
  validates :version, uniqueness: { scope: [:km, :price]}
  validates :year,    presence: true
  validates :eur,     presence: true, numericality: { greater_than: 5000 }
  validates :crawler, presence: true
  
  # Defaults:
  attribute :currency, :string, default: 'EUR'
  attribute :country,  :string, default: 'NL'
  attribute :make,     :string, default: 'BMW i3'
  
  def available?
    if defined? crawler.constantize.available?
      return crawler.constantize.available?(url)
    end
    
    response = HTTParty.head(url)
    response.code == 200
  end
  
  private
  
  def set_eur
    return unless price
    
    case currency
    when 'NOK'
      self.eur = price / 10.0132423
    when 'SEK'
      self.eur = price / 10.805452
    when 'EUR'
      self.eur = price
    end
  end
end
