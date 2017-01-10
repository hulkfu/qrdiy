##
# 通知类。
# 在 status 创建后自动创建，通知相关用户。
#
class Notification < ActiveRecord::Base

  # 为后面的 notification view 服务的，指明模板的名字，而不是操作的action
  enum notify_type: [:relationship, :publication, :comment, :project]

  belongs_to :actor, class_name: :User
  belongs_to :user
  # 通知都是由 status 触发的，比如：发的留言、关注的项目、发布的图片等
  belongs_to :status

  scope :unread, -> { where(read_at: nil) }

  class << self
    def read!(ids = [])
      return if ids.blank?
      Notification.where(id: ids).update_all(read_at: Time.now)
    end

    def unread_count(user)
      Notification.where(user: user).unread.count
    end
  end

  def read?
    self.read_at.present?
  end

  ##
  # 标题，谁 在 哪里 干 了 什么
  # publication：小王 在 趣人网 发布 了 图片
  # relation： 小王 喜欢了 你发布在 趣人网的 图片，小王关注了你
  # comment： 小王 评论了 你发布在 趣人网的 图片
  def title
    who = actor.name

    statusable = status.statusable
    case notify_type  # 根据 statusable 的类型定的
    when "relationship"
      do_what = status.action_name
      relationable = statusable.relationable

      case relationable
      when User
        to_what = relationable.name == user.name ? "你" : relationable.name
      when Project
        to_what = "你的 #{relationable.name}"
      when Status  # publication,包括 comment 的 status
        to_what = "你在 #{relationable.project.name} 的 #{relationable.statusable_name}"
      when Publication
        # Publication 还不能被发生关系，转移到了 status
      end

      "#{who} #{do_what}了 #{to_what}。"
    when "publication"
      at_where = statusable.project.name
      do_what = status.action_name
      to_what = statusable.name

      "#{who} 在你的 #{at_where} #{do_what}了 #{to_what}。"
    when "comment"
      to_what = "你在 #{statusable.project.name} 的 #{status.name}"
      "#{who} 评论了 #{to_what}"
    when "project"
      # 不用通知
    end

  end

  # TODO: 需要显示的内容
  def content

  end
end
