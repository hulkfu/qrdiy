class UserProfile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  enum gender: [ :male, :female, :secret ]

  validates :name, presence: true, length: 2..20, uniqueness: {case_sensitive: false}
  validates :domain, presence: true, length: 4..18, uniqueness: {case_sensitive: false}
  # validates :avatar, presence: true
end
