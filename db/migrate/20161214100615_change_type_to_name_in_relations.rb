class ChangeTypeToNameInRelations < ActiveRecord::Migration[5.0]
  def change
    rename_column :relations, :type, :name
  end
end
