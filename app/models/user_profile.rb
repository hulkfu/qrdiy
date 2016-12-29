class UserProfile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  enum gender: [ :male, :female, :secret ]

  validates :name, presence: true, length: 2..20, uniqueness: {case_sensitive: false}
  validates :domain, presence: true, length: 4..18, uniqueness: {case_sensitive: false}

  # 反正只是更新，就不需要验证 presence 了，空就会默认不变了
  validates :avatar, file_size: { less_than: 10.megabytes.to_i }
end
