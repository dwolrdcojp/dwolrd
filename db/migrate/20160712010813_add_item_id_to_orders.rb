class AddItemIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :item_id, :integer
  end
end
