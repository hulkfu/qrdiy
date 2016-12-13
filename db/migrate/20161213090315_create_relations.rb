class CreateRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :relations do |t|
      t.integer :user_id, index: true

      t.integer :relation, index: true
      t.references :relationable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
