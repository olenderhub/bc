class AddPhotoIdToCars < ActiveRecord::Migration
  def change
    add_column :cars, :photo_id, :integer
  end
end
