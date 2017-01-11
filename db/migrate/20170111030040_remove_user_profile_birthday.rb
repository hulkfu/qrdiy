class RemoveUserProfileBirthday < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_profiles, :birthday, :date
  end
end
