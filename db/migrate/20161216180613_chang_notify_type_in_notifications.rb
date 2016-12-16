class ChangNotifyTypeInNotifications < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :notify_type
    add_column :notifications, :notify_type, :integer

    add_index :notifications, [:user_id, :notify_type]
  end
end
