class CreateSpecies < ActiveRecord::Migration[5.1]
  def change
    create_table :species do |t|
      t.string :name
      t.string :product, default: "vegetables"
        # Note immediately above that ActiveRecord had a problem if this was called "type"
        # because a "type" column is reserved for something specific in ActiveRecord
      t.string :sunlight, default: "full-sun"
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
