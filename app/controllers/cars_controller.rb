class CarsController < ApplicationController
  def index
    @cars = []
    @maxprice = 0
    @minprice = Car.maximum(:price)
    Car.visible.order(:country).group_by(&:country).each do |country, cars|
      data = cars.map do |car|
        @minprice = car.price if car.price < @minprice
        @maxprice = car.price if car.price > @maxprice
        [car.year.strftime('%Q').to_i, car.price ]
      end
      @cars << { name: country, data: data }
    end
    
    @minprice = @minprice.floor(-4)
    @maxprice = @maxprice.floor(-4)
  end
end