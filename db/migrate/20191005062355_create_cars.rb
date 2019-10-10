class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.string :make
      t.string :version
      t.integer :price
      t.integer :km
      t.date :year
      t.string :url
    end
  end
end
