class MoveContentFromPublicationToPublicationable < ActiveRecord::Migration[5.0]
  def change
    %w(attachments ideas comments image_arrays).each do |t|
      add_column t, :content, :text
    end
  end
end
