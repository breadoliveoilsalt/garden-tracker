class CreateGardens < ActiveRecord::Migration[5.1]
  def change
    create_table :gardens do |t|
      t.string :name
      t.string :description
      t.integer :square_feet
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
