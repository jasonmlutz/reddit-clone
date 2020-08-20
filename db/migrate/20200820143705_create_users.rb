class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :fname, null: false
      t.string :lname, null: false

      t.string :password_digest, null: false
      t.string :session_token

      t.index :email, unique: true

      t.timestamps
    end
  end
end
