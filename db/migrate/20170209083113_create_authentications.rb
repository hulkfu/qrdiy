class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.integer :user_id, index: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :authentications, [:provider, :uid]
  end
end
