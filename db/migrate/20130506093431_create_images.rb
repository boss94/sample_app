class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.string :name
      t.string :view
      t.references :vehicle
    end
    add_index :images, :vehicle_id
  end
end
