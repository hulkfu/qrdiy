class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true

      t.integer :action_type
      t.text :content
      t.integer :eventable_id
      t.string :eventable_type, index: true

      t.timestamps
    end

    add_index :events, [:eventable_id, :eventable_type]
  end
end
