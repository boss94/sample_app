class ChangeBodytypeFormatInVehicles < ActiveRecord::Migration
  def change
  	change_column :vehicles, :body_type, :string
  end
end
