class AddCountryToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :country, :string
  end
end
