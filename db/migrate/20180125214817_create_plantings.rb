class CreatePlantings < ActiveRecord::Migration[5.1]
  def change
    create_table :plantings do |t|
      t.integer :quantity
      t.integer :garden_id
      t.integer :species_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
