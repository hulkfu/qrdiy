class ChangeGenderDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :user_profiles, :gender, :integer, default: 0
  end
end
