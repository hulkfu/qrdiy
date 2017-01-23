class RefactorUserAndUserProfilt < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :domain, :string
    add_column :users, :avatar, :string

    add_index :users, :name, unique: true
    add_index :users, :domain, unique: true

    User.find_each do |u|
      %w(name domain).each do |k|
        u.send("#{k}=", "qrdiy_#{u.profile.send(k)}_#{rand.to_s[-4..-1]}") if u && u.try(:profile)
      end
      if file = u.try(:profile).try(:avatar).try(:file).try(:file)
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
