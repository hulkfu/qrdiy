##
# Status 类，记录事件流，一个 statusable 多态类，has_many 了它，边能够记录 status，代表可以有状态的
# 东西，比如 Idea 被 user 在 project 里发布后，就会创建一个 status，然后能够显示在 user 和
# project 的动态列表里。也可以是 user follow 了另一个 user。
class Status < ApplicationRecord
  include Statusable
  # actions 的 enum 顺序不能变，因为数据库是按这个记的，从 0 往后拍
  ACTION_TYPE_NAMES = {add: "发布", change: "更新", remove: "删除"}.freeze
  enum action_type: ACTION_TYPE_NAMES.keys

  belongs_to :statusable, polymorphic: true

  belongs_to :project
  belongs_to :user

  has_many :comments

  # 默认最新的在前
  default_scope { order(created_at: :desc) }

  after_create do
    if user != statusable.user
      Notification.create(actor: user, user: statusable.user, notificationable: self,
        notify_type: "add")
    end
  end

  # OPTIMIZE 需要翻译成多种语言时，可以返回 t(status.name) 的翻译后的结果
  def action_name
    ACTION_TYPE_NAMES[action_type.to_sym]
  end

  def statusable_name
    if statusable_type == "Publication"
      Publication::PUBLISHABLE_TYPE_NAMES[statusable.publishable_type.downcase.to_sym]
    else
      '其他'
    end
  end
end
