class User < ApplicationRecord
  include Relationable  # 可以被关系啦
  extend FriendlyId

  friendly_id :domain

  mount_uploader :avatar, AvatarUploader

  enum role: [:user, :manage, :admin]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lastseenable,
         :omniauthable, :omniauth_providers => [:wechat]

  has_one :profile, class_name: "UserProfile"
  accepts_nested_attributes_for :profile, update_only: true

  has_many :authentications, dependent: :destroy

  has_many :projects
  has_many :publications
  # 参考 Project
  has_many :all_statuses, class_name: :Status
  # 有很多关系，喜欢这个，follow 那个的
  has_many :all_relations, class_name: :Relation
  has_many :all_comments, class_name: :Comment

  # 本用户 user 的 notification 是被其他用户 actor 创建的
  has_many :notifications


  auto_strip_attributes :name,
                        delete_whitespaces: true, nullify: false
  validates :name, presence: true, length: 2..20, on: :update,
    uniqueness: {case_sensitive: false},
    exclusion: { in: %w(管理员 站长 admin root) }

  validates :domain, presence: true, length: 4..18, on: :update,
    uniqueness: {case_sensitive: false},
    format: {
      with: /\A[a-z][a-z0-9_\-]*\z/i,
      message: "请以字母开头，并且只能包含字母、数字、_ 和 - "
    },
    exclusion: { in: %w(admin root) }

    # 反正只是更新，就不需要验证 presence 了，空就会默认不变了
  validates :avatar, file_size: { less_than: 10.megabytes.to_i }

  after_create :update_other_info

  # 不全剩余的信息
  def update_other_info
    # 没有name就有email，根据邮箱名生成临时 name，第三方登录的话就从第三方获取
    self.name = "qrdiy_#{name || email.split('@').first}_#{id}"
    self.domain = name unless domain

    unless avatar
      File.open(LetterAvatar.generate "#{aname}_#{id}", 180) do |f|
        self.avatar = f
      end
    end

    self.save
    self.create_profile
  end

  # 第三方登录
  def self.from_omniauth(auth)
    authentication = Authentication.find_by(provider: auth.provider, uid: auth.uid)
    if authentication
      return authentication.user
    else  # 首次登录
      # create user
      info = auth.info
      # TODO: User email
      name = "#{info.nickname}_#{User.last.id+1}"
      user = User.new(name: name, email: "name@qrdiy.com" )
      user.save(validate: false)
      user.update_other_info
      # TODO other info
      user.authentications.create(provider: auth.provider, uid: auth.uid)
      return user
    end
    # auth.info.nickname city country headimgurl sex unionid
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   user.email = auth.info.email
    #   user.password = Devise.friendly_token[0,20]
    #   user.name = auth.info.name   # assuming the user model has a name
    #   user.image = auth.info.image # assuming the user model has an image
    #   # If you are using confirmable and the provider(s) you use validate emails,
    #   # uncomment the line below to skip the confirmation emails.
    #   # user.skip_confirmation!
    # end
  end


  ## Relation 的糖方法
  Relation::ACTION_TYPES.each do |action_type|
    # 当前用户神否与其他有那种关系？
    define_method "#{action_type}?" do |relationable|
      Relation.relation? self, action_type, relationable
    end

    # 获得relation
    define_method "#{action_type}_relation" do |relationable|
      Relation.get_relation self, action_type, relationable
    end

    # relation 的东西
    define_method "#{action_type}_relations" do
      all_relations.where(name: action_type)
    end
  end

  # 与用户发生关系的东西
  def related_relationables(relationable_type, *action_types)
    # 默认关系, [[]].blank?  #=> false
    action_types = %w(follow like praise) if action_types.flatten.blank?
    relationable_type.classify.constantize.joins(:relations)
      .where('relations.user' => self)
      .where('relations.action_type' => action_types)
      .distinct
  end

  %w(project user).each do |relationable_type|
    define_method "related_#{relationable_type}s" do | *action_types |
      related_relationables relationable_type, action_types
    end
  end

  def related_statuses
    Status.where(user: self.related_users).or(
      Status.where(project: self.related_projects)
    )
  end

  # 重写 manage?，admin 也能 manage
  def manage?
    %w(manage admin).include? role
  end

end
