class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :file_name
      t.string :file_size
      t.string :content_type
      t.string :attachment
      t.string :content
    end
  end
end
