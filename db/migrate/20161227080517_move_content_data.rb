class MoveContentData < ActiveRecord::Migration[5.0]
  def change
    %w(attachments ideas comments image_arrays).each do |t|
      t[0..-2].classify.constantize.all.each do |r|
        if r && r.publication && r.publication.content && r.publication.content.size > 0
          r.content = r.publication.content
          r.save!
        end
      end
    end

    remove_column :publications, :content, :text
  end
end
