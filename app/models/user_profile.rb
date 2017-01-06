class UserProfile < ApplicationRecord
  belongs_to :user

  GENDER_TYPE_NAMES = {secret: '保密', female: '女', male: '男'}.freeze
  GENDER_TYPES = GENDER_TYPE_NAMES.keys.freeze
  enum gender: GENDER_TYPES

  auto_strip_attributes :homepage,
                        delete_whitespaces: true, nullify: false
  auto_strip_attributes :location, :description,
                        squish: true, nullify: false

  validates :homepage, length: 0..100
  validates :location, length: 0..50
  validates :gender, inclusion: GENDER_TYPES.map(&:to_s)
  # validates :birthday
  validates :description, length: 0..2000

  def gender_name
    GENDER_TYPE_NAMES(gender.to_sym)
  end

end
