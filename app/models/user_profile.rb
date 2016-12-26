class UserProfile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  enum gender: [ :male, :female, :secret ]

  # 用 domain 来当做默认 find 属性
  def to_param
    domain
  end
end
