class AddTimestampsToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :created_at, :timestamp
    add_column :cars, :updated_at, :timestamp
  end
end
