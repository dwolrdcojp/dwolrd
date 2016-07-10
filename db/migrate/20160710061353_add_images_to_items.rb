class AddImagesToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :images, :json
  end
end
