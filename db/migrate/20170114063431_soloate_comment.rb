class SoloateComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :user_id, :integer
    add_column :comments, :commentable_type, :string
    add_column :comments, :commentable_id, :integer
    add_column :comments, :created_at, :datetime
    add_column :comments, :updated_at, :datetime
    add_column :comments, :content_html, :text

    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]

    # migrate data
    Comment.find_each do |c|
      c.commentable = c.status if c.status
      c.content_html = c.content
      # should temp as publishable, and belongs_to :status
      c.user = c.publication.user
      c.publication.delete
      c.save
    end

    remove_column :comments, :status_id
  end
end
