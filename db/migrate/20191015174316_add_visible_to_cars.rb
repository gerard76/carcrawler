class AddVisibleToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :visible, :boolean, default: true
  end
end
