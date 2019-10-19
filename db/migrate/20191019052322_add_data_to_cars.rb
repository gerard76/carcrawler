class AddDataToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :data, :json, default: {}
  end
end
