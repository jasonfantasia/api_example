class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: true
      t.string :password_digest, null: false
      t.string :auth_token
      t.datetime :auth_token_create_date

      t.timestamps
    end

    add_index :users, [:auth_token, :auth_token_create_date]
    add_index :users, :auth_token, unique: true
  end
end
