class ChangeEventsTableName < ActiveRecord::Migration[5.0]
  def change
    rename_table :events, :statuses
    rename_column :statuses, :eventable_id, :statusable_id
    rename_column :statuses, :eventable_type, :statusable_type
  end
end
