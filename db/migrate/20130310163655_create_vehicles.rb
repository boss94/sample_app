class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.references :model
      t.string :additional_details
      t.string :registration
      t.integer :registration_year
      t.string :fuel
      t.integer :mileage
      t.boolean :mileage_warranty
      t.float :price
      t.string :color
      t.string :doors
      t.boolean :body_type
      t.text :equipment
      t.text :notes
      t.string :equipment_typetext
      t.text :equipment_fulltext
      t.string :notes_typetext
      t.text :notes_fulltext

      t.timestamps
    end
    add_index :vehicles, :model_id
  end
end
