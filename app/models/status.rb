##
# Status 类，记录事件流，一个 statusable 多态类，has_many 了它，边能够记录 status，代表可以有状态的
# 东西，比如 Idea 被 user 在 project 里发布后，就会创建一个 status，然后能够显示在 user 和
# project 的动态列表里。也可以是 user follow 了另一个 user。
class Status < ApplicationRecord
  include Relationable
  # actions 的 enum 顺序不能变，因为数据库是按这个记的，从 0 往后拍
  # status 的 action type，根据它生成 status view 或 判定它的类型
  ACTION_TYPE_NAMES = {publication: "发布", change: "更新", remove: "删除",
    follow: "关注", like: "喜欢", praise: "赞",
    comment: "评论", project: "创建"}.freeze
  enum action_type: ACTION_TYPE_NAMES.keys.freeze

  belongs_to :statusable, polymorphic: true

  belongs_to :project
  belongs_to :user

  has_many :comments
  has_many :notifications

  # 默认最新的在前
  default_scope { order(id: :desc) }

  scope :without_comments, -> { where.not(action_type: "comment")}

  after_create :create_notifications

  # 创建通知。
  # TODO 异步创建通知。但是目前只是给 owner 一个人创建了通知，因此不必。
  # 通知里要显示自己关心的东西，即自己参与的东西，能激励用户进一步互动的东西
  def create_notifications
    # 1. 基本信息
    actor = user  # 触发通知的人，也就是触发这个 status 的人
    receiver_ids = []  # 接收通知的人
    notify_type = nil   # 通知的类型

    # 2. 根据不同的statusable_type 和 action_type
    #    得出相应的 notify_type，及对应的响应的通知用户
    case statusable
    ## 发生关系:
    # 关注我, 关注我的项目, 赞我的项目, 赞我的内容, 喜欢我的内容
    when Relation
      # 负面关系就不发通知了
      return if Relation::POSITIVE_RELATIONS.exclude?(statusable.action_type)
      notify_type = "relationship"
      receiver = statusable.relationable_user
      receiver_ids << receiver.id if actor != receiver

    ## 发布东西
    when Publication
      publishable = statusable.publishable
      case publishable
      # 我的东西有人评论
      when Comment
        commented_status = publishable.status
        notify_type = "comment"
        # 我的东西
        receiver = commented_status.user
        receiver_ids << receiver.id if actor != receiver
        # TODO: 我喜欢的东西

      # 在我的项目里发布内容
      else
        notify_type ="publication"
        receiver = publishable.project.user
        receiver_ids << receiver.id if actor != receiver
      end
    when Project  # 创建 DIY
      return
    end

    # project owner

    # project following

    # user following

    # publication owner

    # 3. 记入 mention users
    # 别人提到我，包括我的评论有人回复

    # 4. 为所有接收者创建通知
    receiver_ids.each do |uid|
      notifications.create(user_id: uid, actor_id: actor.id, notify_type: notify_type)
    end
  end

  # OPTIMIZE 需要翻译成多种语言时，可以返回 t(status.name) 的翻译后的结果
  def action_name
    ACTION_TYPE_NAMES[action_type.underscore.to_sym]
  end

  # 生成 status 的东西的 name
  def statusable_name
    case statusable
    when Publication
      statusable.name  # statusable 就是 publication
    when Project
      "DIY"
    when Relation
      # user 或 project 的 name
      # 或 status 的 statusable_name，因为可以和一个 status 发生关系，最好还是回到这里找到
      # 真正的 name
      statusable.relationable.name
    end
  end

  # status 想显示的 name
  def name
    # 如果是评论的 status，那么它的 name 就是评论的 status 的 statusable_name
    statusable.is_a?(Publication) && statusable.publishable.is_a?(Comment) ?
      statusable.publishable.status.statusable_name
      : statusable_name
  end
end
