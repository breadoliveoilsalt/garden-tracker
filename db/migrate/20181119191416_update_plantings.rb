class UpdatePlantings < ActiveRecord::Migration[5.1]
  def change
    add_column :plantings, :date_planted, :date, default: Date.current
    add_column :plantings, :date_harvested, :date
  end
end
