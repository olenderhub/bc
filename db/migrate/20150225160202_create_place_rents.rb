class CreatePlaceRents < ActiveRecord::Migration
  def change
    create_table :place_rents do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.decimal :price
      t.integer :parking_id
      t.integer :car_id

      t.timestamps null: false
    end
  end
end