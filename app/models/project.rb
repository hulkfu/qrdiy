class Project < ApplicationRecord
  # 项目也有很多事件，比如创建。当项目不在时，也还是算用户的，需要在其也没显示，只是项目名标识一下
  include Statusable
  include Relationable

  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  # 用来查找 project 所有的 statuses
  has_many :all_statuses, class_name: :Status

  has_many :publications

  after_create :create_tmp_profile

  def create_tmp_profile
    if avatar.blank?
      File.open(LetterAvatar.generate(PinYin.of_string(name.first).first, 180)) do |f|
        self.avatar = f
      end
      save
    end
  end
end
