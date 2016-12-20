class ChangeNotifications < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :publication_id

    add_column :notifications, :notificationable_id, :integer
    add_column :notifications, :notificationable_type, :string
  end
end
