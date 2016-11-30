class CreatePublications < ActiveRecord::Migration[5.0]
  def change
    create_table :publications do |t|
      t.references :user, foreign_key: true, index: true
      t.references :project, foreign_key: true, index: true
      t.text :content_html
      t.integer :publishable_id
      t.string :publishable_type

      t.timestamps
    end

    add_index :publications, [:publishable_id, :publishable_type]
  end
end
