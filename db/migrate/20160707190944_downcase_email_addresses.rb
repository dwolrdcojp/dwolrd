class DowncaseEmailAddresses < ActiveRecord::Migration[5.0]
  
  def up
    # Downcase all User emails
    User.update_all('email = LOWER(email)')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
