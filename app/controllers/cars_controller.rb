class CarsController < ApplicationController
  def index
    @cars = []
    @maxprice = 0
    @minprice = Car.maximum(:eur)
    Car.visible.order(:country).group_by(&:country).each do |country, cars|
      data = cars.map do |car|
        @minprice = car.eur if car.eur < @minprice
        @maxprice = car.eur if car.eur > @maxprice
        [car.year.strftime('%Q').to_i, car.eur ]
      end
      @cars << { name: country, data: data }
    end
    
    @minprice = @minprice.floor(-4)
    @maxprice = @maxprice.floor(-4)
  end
end