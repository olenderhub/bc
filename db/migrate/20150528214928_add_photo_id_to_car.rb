class AddPhotoIdToCar < ActiveRecord::Migration
  def change
    add_index :cars, :photo_id
  end
end
