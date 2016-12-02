class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lastseenable

  has_one :user_profile
  has_many :projects
  has_many :publications
  # 参考 Project
  has_many :all_statuses, class_name: :Statue
  has_many :statuses, as: :statusable

  after_create :create_profile

  # TODO 第三方登录，获得名号
  def create_profile
    # 根据邮箱名生成临时 name
    tmp_name = "#{email.split('@').first}_#{id}"
    create_user_profile(name: tmp_name, domain: tmp_name)
  end
end
