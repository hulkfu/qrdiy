class ChangeProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :desc, :string
    add_column :projects, :avatar, :string
  end
end
