class AddUsernameToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :username, :string
  end
end
