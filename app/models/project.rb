class Project < ApplicationRecord
  # 项目也有很多事件，比如创建。当项目不在时，也还是算用户的，需要在其也没显示，只是项目名标识一下
  include Statusable
  include Relationable

  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  # 用来查找 project 所有的 statuses
  has_many :all_statuses, class_name: :Status

  has_many :publications

  # before validates
  auto_strip_attributes :name, :desc,
                        delete_whitespaces: true, nullify: false
  auto_strip_attributes :description,
                        squish: true, nullify: false

  validates :name, presence: true, length: 2..20, uniqueness: { case_sensitive: false }
  validates :desc, presence: true, length: 2..50
  validates :description, length: 0..10000
  validates :avatar, file_size: { less_than: 10.megabytes.to_i }

  after_create :create_tmp_profile

  def create_tmp_profile
    if avatar.blank?
      File.open(LetterAvatar.generate(PinYin.abbr(name), 180)) do |f|
        self.avatar = f
      end
      save
    end
  end

  def status_action_type
    "project"
  end
end
