class UserProfile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  GENDER_TYPE_NAMES = {secret: '保密', female: '女', male: '男'}.freeze
  GENDER_TYPES = GENDER_TYPE_NAMES.keys.freeze
  enum gender: GENDER_TYPES

  # TODO: add exclusion,name > domain
  validates :name, presence: true, length: 2..20,
    uniqueness: {case_sensitive: false}, exclusion: { in: %w(admin superuser) }
  validates :domain, presence: true, length: 4..18,
    uniqueness: {case_sensitive: false}, exclusion: { in: %w(admin superuser) }

  # 反正只是更新，就不需要验证 presence 了，空就会默认不变了
  validates :avatar, file_size: { less_than: 10.megabytes.to_i }
  validates :homepage, length: 0..100
  validates :location, length: 0..50
  validates :gender, inclusion: GENDER_TYPES.map(&:to_s)
  # validates :birthday
  validates :description, length: 0..2000


  def gender_name
    GENDER_TYPE_NAMES(gender.to_sym)
  end

end
