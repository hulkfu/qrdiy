class UserProfile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  enum gender: [ :male, :female, :secret ]

  def to_param
    domain
  end
end
