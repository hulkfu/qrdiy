class AddDomainToUserProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :user_profiles, :domain, :string
    add_column :user_profiles, :domain_updated_at, :datetime, default: nil

    add_column :user_profiles, :name_updated_at, :datetime, default: nil

    add_index :user_profiles, :domain, unique: true
    add_index :user_profiles, :name, unique: true
  end
end
