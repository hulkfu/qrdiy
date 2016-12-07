class CreateImageArray < ActiveRecord::Migration[5.0]
  def change
    create_table :image_arrays do |t|
      t.string :content
      t.string :images, array: true, default: []
      t.string :file_names, array: true, default: []
      t.string :file_sizes, array: true, default: []
      t.string :content_types, array: true, default: []
    end
  end
end
