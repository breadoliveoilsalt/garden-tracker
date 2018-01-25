class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :provider
      t.string :uid
      t.string :oath_token
      t.timestamps null: false
    end
  end
end
