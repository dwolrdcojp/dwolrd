class AddShippingPriceToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :shipping_price, :decimal
  end
end
