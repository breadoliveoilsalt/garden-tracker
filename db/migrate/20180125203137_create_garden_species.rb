class CreateGardenSpecies < ActiveRecord::Migration[5.1]
  def change
    create_table :garden_species do |t|
      t.integer :garden_id
      t.integer :species_id
    end
  end
end
