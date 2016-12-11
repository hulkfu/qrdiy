class DropQrTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :prints
    drop_table :codes
  end
end
