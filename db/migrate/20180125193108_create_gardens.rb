class CreateGardens < ActiveRecord::Migration[5.1]
  def change
    create_table :gardens do |t|
      t.string :name
      t.string :description
      t.integer :square_feet
    end
  end
end
