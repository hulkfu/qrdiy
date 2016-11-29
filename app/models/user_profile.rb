class UserProfile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  enum status: [ :male, :female, :secret ]
end
