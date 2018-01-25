class CreateSpecies < ActiveRecord::Migration[5.1]
  def change
    create_table :species do |t|
      t.string :name
      t.string :type
      t.string :sunlight
    end
  end
end
