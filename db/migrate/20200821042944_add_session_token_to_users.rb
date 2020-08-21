class AddSessionTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:users, :session_token, false)
    add_index :users, :session_token, unique: true
  end
end
