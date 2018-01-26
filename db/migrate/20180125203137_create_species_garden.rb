class CreateSpeciesGarden < ActiveRecord::Migration[5.1]
  def change
    create_table :species_garden do |t|
      t.integer :species_id
      t.integer :garden_id
    end
  end
end
