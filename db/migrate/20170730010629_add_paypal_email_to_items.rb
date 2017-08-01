class AddPaypalEmailToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :paypal_email, :string
  end
end
