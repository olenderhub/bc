class AddIndexToParkings < ActiveRecord::Migration
  def change
    add_index :parkings, :owner_id
    add_index :parkings, :address_id
  end
end
