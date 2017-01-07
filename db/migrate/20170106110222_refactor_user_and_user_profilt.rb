class RefactorUserAndUserProfilt < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :domain, :string
    add_column :users, :avatar, :string

    add_index :users, :name, unique: true
    add_index :users, :domain, unique: true

    User.find_each do |u|
      %w(name domain).each do |k|
        u.send("#{k}=", u.profile.send(k))
      end
      if file = u.profile.try(:avatar).try(:file).try(:file)
        File.open(file) do |f|
          u.avatar = f || ""
        end
      end

      u.save!
    end

    %w(name domain avatar).each do |k|
      remove_column :user_profiles, k, :string
    end
  end
end
