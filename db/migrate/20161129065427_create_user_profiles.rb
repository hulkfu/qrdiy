class CreateUserProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_profiles do |t|
      t.belongs_to :user, index: true, unique: true, foreign_key: true
      t.string :name
      t.string :avatar
      t.string :homepage
      t.string :location
      t.integer :gender
      t.date :birthday
      t.text :description

      t.timestamps
    end
  end
end
