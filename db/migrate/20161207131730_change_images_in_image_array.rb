class ChangeImagesInImageArray < ActiveRecord::Migration[5.0]
  def change
    rename_column :image_arrays, :images, :image_array
  end
end
