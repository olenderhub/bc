class AddIndexToCars < ActiveRecord::Migration
  def change
    add_index :cars, :owner_id
  end
end
