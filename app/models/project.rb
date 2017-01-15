class Project < ApplicationRecord
  # 项目也有很多事件，比如创建。当项目不在时，也还是算用户的，需要在其也没显示，只是项目名标识一下
  include Statusable
  include Relationable

  extend FriendlyId
  friendly_id :name

  # 在 project show 里每页显示的 status 的个数
  STATUSES_PER_PAGE = 18

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

  def content_type
    "project"
  end

  def project
    self
  end

  # Project 里只需要出现有用的东西，
  # 即 pubications 的发布，项目的创建，有人 follow 项目（好来欢迎）
  def statuses_to_show
    all_statuses.where(
      action_type: %w(publication follow project) )
  end

  # 返回一个 status 在 project show 里的 page 页数
  # TODO 如果没有 project 呢？
  def page_of_status(status)
    before_count = statuses_to_show.where("id > ?", status.id).count
    before_count / STATUSES_PER_PAGE + 1
  end
end
