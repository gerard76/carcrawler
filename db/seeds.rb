# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Car.where("version ilike '%120ah%' or version ilike '%120_ah%'").update_all(data: { ah: 120 })
Car.where("version ilike '%94ah%' or version ilike '%94_ah%'").update_all(data: { ah: 94 })
Car.where("version ilike '%60ah%' or version ilike '%60_ah%'").update_all(data: { ah: 60 })

Car.where("year < '2016-06-01'").where("data::text = '{}'").update_all(data: { ah: 60 })

Car.where("version ilike '%rex%' OR version ilike '%range%'").each do |car|
  car.update(data: car.data.merge({rex: true}))
end