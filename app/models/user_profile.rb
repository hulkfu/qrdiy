class UserProfile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  enum gender: [ :male, :female, :secret ]

  validates :name, presence: true, length: 2..20, uniqueness: {case_sensitive: false}
  validates :domain, presence: true, length: 4..18, uniqueness: {case_sensitive: false}
  validates :avatar, presence: true
  # 用 domain 来当做默认 find 属性
  def to_param
    domain
  end
end
