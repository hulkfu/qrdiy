class ChangeCodesIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :codes, :id, :string
    change_column :prints, :code_id, :string
  end
end
