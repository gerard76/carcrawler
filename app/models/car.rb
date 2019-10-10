class Car < ApplicationRecord
  validates :url, uniqueness: true
  validates :version, uniqueness: { scope: [:km, :price]}
  validates :year, presence: true
  validates :price, presence: true
end
