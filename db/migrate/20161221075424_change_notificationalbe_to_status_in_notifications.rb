class ChangeNotificationalbeToStatusInNotifications < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :notificationable_id
    remove_column :notifications, :notificationable_type

    add_column :notifications, :status_id, :integer
  end
end
