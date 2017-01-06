class RemoveSluggedForProjects < ActiveRecord::Migration[5.0]
  def change
    drop_table :friendly_id_slugs

    remove_column :projects, :slug
  end
end
