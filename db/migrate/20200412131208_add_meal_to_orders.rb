class AddMealToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :meal, :string
  end
end
