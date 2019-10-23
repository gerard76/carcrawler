require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:car) { build :car }
  
  subject { car }
  it { is_expected.to be_valid }
  
  describe "price=" do
    it "adds tax for dutch prices" do
      car.country = 'NL'
      car.version = '22 kWh Navi Prof/Warmtepomp/Snellaadfunctie Ex BTW'
      car.price   = 10000
      
      expect{car.valid?}.to change{car.eur}.to 12100
    end
  end
end
