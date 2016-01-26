class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.float :temperature, null: false
      t.float :humidity, null: false
      t.timestamps
    end

    add_index :measurements, :created_at
  end
end
