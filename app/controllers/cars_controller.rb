class CarsController < ApplicationController
  def index
    @cars = []
    Car.order(:country).group_by(&:country).each do |country, cars|
      data = cars.map { |c| [c.year.strftime('%Q').to_i, c.price ]}
      @cars << { name: country, data: data }
    end
  end
end