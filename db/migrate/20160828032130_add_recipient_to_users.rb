class AddRecipientToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :recipient, :string
  end
end
