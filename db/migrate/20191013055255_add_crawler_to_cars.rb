class AddCrawlerToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :crawler, :string
  end
end
