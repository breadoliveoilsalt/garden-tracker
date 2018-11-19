class UpdateSpecies < ActiveRecord::Migration[5.1]
  def change
    rename_column :species, :product, :category
    add_column :species, :days_to_maturity, :date
  end
end
