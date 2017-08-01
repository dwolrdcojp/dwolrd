class AddDetailsToPaymentNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_notifications, :params, :text
    add_column :payment_notifications, :cart_id, :integer
    add_column :payment_notifications, :status, :string
    add_column :payment_notifications, :transaction_id, :string
  end
end
