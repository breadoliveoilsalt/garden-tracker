class UpdatePlantings < ActiveRecord::Migration[5.1]
  def change
    add_column :plantings, :date_planted, :date
    add_column :plantings, :date_harvested, :date
    add_column :plantings, :expected_maturity_date, :date
  end
end
