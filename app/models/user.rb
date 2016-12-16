class User < ApplicationRecord
  include Relationable  # 可以被关系啦
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
  # 有很多关系，喜欢这个，follow 那个的
  has_many :all_relations, class_name: :Relation
  has_many :statuses, as: :statusable
  # 本用户 user 的 notification 是被其他用户 actor 创建的
  has_many :notifications

  after_create :create_tmp_profile

  # find user by domain, if not exist reutrn nil
  def self.find_by_domain(domain)
    UserProfile.find_by(domain: domain).try(:user)
  end

  ## Relation 的糖方法
  Relation::NAMES.keys.each do |name|
    # 当前用户神否与其他有那种关系？
    define_method "#{name}?" do |relationable|
      Relation.relation? self, name, relationable
    end

    # 获得relation
    define_method "#{name}_relation" do |relationable|
      Relation.get_relation self, name, relationable
    end

    # relation 的东西
    define_method "#{name}_relations" do
      all_relations.where(name: name)
    end
  end


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
