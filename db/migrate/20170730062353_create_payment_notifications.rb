class CreatePaymentNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_notifications do |t|

      t.timestamps
    end
  end
end
