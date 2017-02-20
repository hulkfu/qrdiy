class RemoveUnneededIndexes < ActiveRecord::Migration[5.0]
  def change
    remove_index :notifications, name: "index_notifications_on_user_id"
  end
end
