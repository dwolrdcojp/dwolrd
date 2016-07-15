class AddNameOfAttrForFilepickerUrlToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :filepicker_url, :string
  end
end
