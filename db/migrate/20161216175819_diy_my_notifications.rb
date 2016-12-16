class DiyMyNotifications < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :target_type
    remove_column :notifications, :target_id
    remove_column :notifications, :second_target_type
    remove_column :notifications, :second_target_id
    remove_column :notifications, :third_target_type
    remove_column :notifications, :third_target_id

    add_column :notifications, :publication_id, :integer

  end
end
