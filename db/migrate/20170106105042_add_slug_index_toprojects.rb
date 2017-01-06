class AddSlugIndexToprojects < ActiveRecord::Migration[5.0]
  def change
    add_index :projects, :slug, :unique => true
  end
end
