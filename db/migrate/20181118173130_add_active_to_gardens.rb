class AddActiveToGardens < ActiveRecord::Migration[5.1]
  def change
    add_column :gardens, :active, :boolean, default: true
  end
end
