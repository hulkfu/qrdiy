class RefactorPublishableContent < ActiveRecord::Migration[5.0]
  def change
    %w(attachments ideas image_arrays).each do |table|
      remove_column table, :content
    end

    add_column :publications, :content, :text
  end
end
