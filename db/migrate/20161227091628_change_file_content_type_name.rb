class ChangeFileContentTypeName < ActiveRecord::Migration[5.0]
  def change
    rename_column :attachments, :content_type, :file_type
    rename_column :image_arrays, :content_types, :file_types
  end
end
