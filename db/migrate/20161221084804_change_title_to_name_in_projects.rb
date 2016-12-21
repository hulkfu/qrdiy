class ChangeTitleToNameInProjects < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :title, :name
  end
end
