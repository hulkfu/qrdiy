class AddSlugToprojects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :slug, :string, index: true, unique: true
  end
end
