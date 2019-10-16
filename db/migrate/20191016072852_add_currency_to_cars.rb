class AddCurrencyToCars < ActiveRecord::Migration[6.0]
  def change
    add_column    :cars, :currency, :string
    rename_column :cars, :price, :eur
    add_column    :cars, :price, :integer
  end
end
