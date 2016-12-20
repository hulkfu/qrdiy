# Auto generate with notifications gem.
class Notification < ActiveRecord::Base
  DEFAULT_AVATAR = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPAAAADwCAMAAAAJixmgAAAAFVBMVEWkpKSnp6eqqqq3t7fS0tLV1dXZ2dmshcKEAAAAtklEQVR4Ae3XsRGAAAjAQFRk/5HtqaTz5H+DlInvAQAAAAAAAAAAAAAAAAAAAACymiveO6o7BQsWLFiwYMGCBS8PFixYsGDBggULFixYsGDBggULFixYsGDBggULFixYsGDBc4IFCxYsWLBgwYIFC14ZfOeAPRQ8IliwYMGCBQsWLFiwYMGCBQsWLFiwYMGCBQsWLFiwYMGCBQsWLFiwYMGCBQv+JQAAAAAAAAAAAAAAAAAAAOAB4KJfdHmj+kwAAAAASUVORK5CYII='

  enum notify_type: [:follow, :like, :add]

  belongs_to :actor, class_name: :User
  belongs_to :user
  # 记录触发通知的东西，比如：发的留言、关注的项目、发布的图片等
  belongs_to :notificationable, polymorphic: true

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
    self.actor.avatar.url
  end

  def actor_profile_url
    return '#' if self.actor.blank?
    self.actor.profile
  end

end
