class ChangeNameToActionTypeInRelations < ActiveRecord::Migration[5.0]
  def change
    rename_column :relations, :name, :action_type
  end
end
