class AddMaxPricePerHourToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :max_price_per_hour, :decimal
  end
end
