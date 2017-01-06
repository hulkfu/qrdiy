class RefactorUserAndUserProfilt < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :domain, :string
    add_column :users, :avatar, :string

    add_index :users, :name, unique: true
    add_index :users, :domain, unique: true

    User.find_each do |u|
      %w(name domain avatar).each do |k|
        u.send("#{k}=", u.profile.send(k))
        u.save!
      end
    end

    %w(name domain avatar).each do |k|
      remove_column :user_profiles, k, :string
    end
  end
end
