class ChangeRelationToTypeInRelations < ActiveRecord::Migration[5.0]
  def change
    rename_column :relations, :relation, :type
  end
end
