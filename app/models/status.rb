##
# Status 类，记录事件流，一个 statusable 多态类，has_many 了它，边能够记录 status，代表可以有状态的
# 东西，比如 Idea 被 user 在 project 里发布后，就会创建一个 status，然后能够显示在 user 和
# project 的动态列表里。也可以是 user follow 了另一个 user。
class Status < ApplicationRecord
  # actions 的 enum 顺序不能变，因为数据库是按这个记的，从 0 往后拍
  ACTION_TYPE_NAMES = {add: "发布", change: "更新", remove: "删除",
    follow: "关注", like: "喜欢", praise: "赞"}.freeze
  enum action_type: ACTION_TYPE_NAMES.keys.freeze

  belongs_to :statusable, polymorphic: true

  belongs_to :project
  belongs_to :user

  has_many :comments
  has_many :notifications

  # 默认最新的在前
  default_scope { order(created_at: :desc) }

  after_create :create_notifications

  # 创建通知。TODO 异步创建通知
  def create_notifications
    # 1. 基本信息
    actor = user  # 触发通知的人，也就是触发这个 status 的人
    receiver_ids = []  # 接收通知的人

    # 2. 根据不同的statusable_type 和 action_type
    #    得出相应的 notify_type，及对应的响应的通知用户
    case statusable
    when Relation
      notify_type = "relationship"
      receiver = statusable.relationable_user
      receiver_ids << receiver.id if actor != receiver

    when Publication

    when Project

    end

    # project owner

    # project following

    # user following

    # publication owner

    # 3. 记入 mention users


    # 4. 为所有接收者创建通知
    Notification.bulk_insert(set_size: 100) do |worker|
      receiver_ids.each do |uid|
        worker.add(user_id: uid, actor_id: actor.id, status_id: self.id, notify_type: notify_type)
      end
    end
  end

  # OPTIMIZE 需要翻译成多种语言时，可以返回 t(status.name) 的翻译后的结果
  def action_name
    ACTION_TYPE_NAMES[action_type.to_sym]
  end

  def statusable_name
    case statusable
    when Publication
      statusable.name
    when Project
      "DIY"
    when Relation
      # user 或 project 的 name
      statusable.relationable.name
    else
      "其他"
    end
  end
end
