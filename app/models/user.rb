class User < ApplicationRecord
  enum role: [:user, :manage, :admin]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lastseenable

  has_one :profile, class_name: "UserProfile"
  has_many :projects
  has_many :publications
  # 参考 Project
  has_many :all_statuses, class_name: :Status
  has_many :statuses, as: :statusable

  after_create :create_tmp_profile

  # TODO 第三方登录，获得名号
  def create_tmp_profile
    # 根据邮箱名生成临时 name
    tmp_name = "#{email.split('@').first}_#{id}"
    create_profile(name: tmp_name, domain: tmp_name)
  end

  # 重写 manage?，admin 也能 manage
  def manage?
    %w(manage admin).include? role
  end

  # 映射 user profile 的常用方法
  %w(avatar name domain).each do |m|
    define_method m do
      profile.__send__ m
    end
  end
end
