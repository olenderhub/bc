class AddIndexToPlaceRents < ActiveRecord::Migration
  def change
    add_index :place_rents, :parking_id
    add_index :place_rents, :car_id
  end
end
