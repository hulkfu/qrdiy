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
         :omniauthable, :omniauth_providers => [:wechat, :weibo]

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
    format: {
      with: /\A\D/i,
      message: "不能以数字开头"
    },
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

  # 只在创建时补全其他信息
  before_validation :update_other_info, if: Proc.new { |u| u.created_at.nil?}
  after_create :create_profile

  ##
  # 补全剩余的信息，使顺利注册。
  def update_other_info
    # 没有name就有email，根据邮箱名生成临时 name，第三方登录的话就从第三方获取
    original_name = name || email.split('@').first
    random_string = "#{User.last.id}#{SecureRandom.hex(2)}"

    self.name = original_name
    unless valid_attribute?(:name)
      self.name = "qrdiy_#{name}_#{random_string}"
    end

    self.domain = name if domain.blank?
    unless valid_attribute?(:domain)
      self.domain = "qrdiy_#{random_string}"
    end
    self.email = "#{name}@temp.qrdiy.com" if email.blank?

    if avatar.file.nil?
      File.open(LetterAvatar.generate(PinYin.abbr("#{original_name}#{random_string}"), 180)) do |f|
        self.avatar = f
      end
    end
  end

  # 第三方登录
  def self.from_omniauth(auth)
    authentication = Authentication.find_by(provider: auth.provider, uid: auth.uid)

    if authentication   # 已经登录过
      return authentication.user
    else  # 首次登录
      provider = auth.provider
      info = auth.info
      data = {}
      # 归一化数据
      case provider
      when "wechat"
        data[:provider] = "wechat"
        data[:uid] = info.unionid
        data[:name] = info.nickname
        data[:avatar] = info.headimgurl
        data[:location] = "#{info.country}#{info.city}"
        data[:gender] = info.sex
      when "weibo"
        data[:provider] = "weibo"
        data[:uid] = auth.uid
        data[:name] = info.nickname
        data[:avatar] = info.image
        data[:location] = info.location
      end

      # create user
      user = User.new(name: data[:name],
        remote_avatar_url: data[:avatar],
        password: Devise.friendly_token[0,20])

      if user.save!
        user.profile.update_attributes(location: data[:location], gender: data[:gender])
        user.authentications.create(provider: data[:provider], uid: data[:uid])
        return user
      else
        return nil
      end
    end
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
