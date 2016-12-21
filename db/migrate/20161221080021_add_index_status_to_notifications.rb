class AddIndexStatusToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_index :notifications, :status_id
  end
end
