# Auto generate with notifications gem.
class Notification < ActiveRecord::Base
  DEFAULT_AVATAR = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPAAAADwCAMAAAAJixmgAAAAFVBMVEWkpKSnp6eqqqq3t7fS0tLV1dXZ2dmshcKEAAAAtklEQVR4Ae3XsRGAAAjAQFRk/5HtqaTz5H+DlInvAQAAAAAAAAAAAAAAAAAAAACymiveO6o7BQsWLFiwYMGCBS8PFixYsGDBggULFixYsGDBggULFixYsGDBggULFixYsGDBc4IFCxYsWLBgwYIFC14ZfOeAPRQ8IliwYMGCBQsWLFiwYMGCBQsWLFiwYMGCBQsWLFiwYMGCBQsWLFiwYMGCBQv+JQAAAAAAAAAAAAAAAAAAAOAB4KJfdHmj+kwAAAAASUVORK5CYII='

  # 为后面的 notification view 服务的，指明模板的名字，而不是操作的action
  enum notify_type: [:relationship, :publication, :project]

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

  def actor_name
    return '' if self.actor.blank?
    self.actor.name
  end

  def actor_avatar_url
    return DEFAULT_AVATAR if self.actor.blank?
    self.actor.avatar.small.url.to_s
  end

  def actor_profile_url
    return '#' if self.actor.blank?
    self.actor.profile
  end

  def title
    if actor_name
      pre = "#{actor_name} #{status.action_name}了 "

      pre << "#{status.statusable_name}。"
    else
      "相关信息已删除。"
    end
  end
end
