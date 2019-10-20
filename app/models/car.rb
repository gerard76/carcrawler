class Car < ApplicationRecord
  scope :visible,   -> { where(visible: true) }
  scope :for_graph, -> { visible.order(:country).group_by(&:country) }
  
  before_validation :cleanup
  before_validation :set_eur
    
  # Validations
  validates :eur,     presence: true, numericality: { greater_than: 5000 }
  validates :year,    presence: true
  validates :crawler, presence: true
  validates :url,     uniqueness: true
  validates :version, uniqueness: { scope: [:km, :price]}
  
  # Defaults:
  attribute :currency, :string, default: 'EUR'
  attribute :country,  :string, default: 'NL'
  attribute :make,     :string, default: 'BMW'
  attribute :model,    :string, default: 'i3'
  
  # Searching in json with Ransack
  Car.pluck(Arel.sql("distinct json_object_keys(data)")).each do |key|
    ransacker key do |parent|
      Arel::Nodes::InfixOperation.new('->>', parent.table[:data], Arel::Nodes.build_quoted(key))
    end
  end
  
  # Instance methods:
  def available?
    if defined? crawler.constantize.available?
      return crawler.constantize.available?(url)
    end
    
    response = HTTParty.head(url)
    response.code == 200
  end
  
  def type
    "#{make} #{model}"
  end
  
  private
  
  def cleanup
    self.version = version.strip.sub(/^#{type}/, '').strip
    
    self.km = km.to_s.gsub(/[^0-9]/, '')
    self.km *= 10 if country == 'SE'
    
    self.price = price.to_s.gsub(/[^0-9]/, '')
    
    if version =~ /ex.*btw/i && !price.nil? && country == 'NL'
      self.price  *= 1.21 
    end
  end
  
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
