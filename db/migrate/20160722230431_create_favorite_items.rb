class CreateFavoriteItems < ActiveRecord::Migration[5.0]
  def change
    create_table :favorite_items do |t|
      t.integer :item_id
      t.integer :user_id

      t.timestamps
    end
  end
end
