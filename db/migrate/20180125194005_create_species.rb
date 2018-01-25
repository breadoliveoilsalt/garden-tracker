class CreateSpecies < ActiveRecord::Migration[5.1]
  def change
    create_table :species do |t|
      t.string :name
      t.string :type, default: "vegetable"
      t.string :sunlight
      t.timestamps null: false
    end
  end
end
