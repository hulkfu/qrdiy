##
# 提供通知
class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.includes(:actor).order('id desc')

    unread_ids = []
    @notifications.each do |n|
      unread_ids << n.id unless n.read?
    end
    Notification.read!(unread_ids)

    # 对于已经取出来的，其 read_at 还是不变的
    @notification_groups = @notifications.group_by { |note| note.created_at.to_date }
  end

  def clean
    Notification.where(user_id: current_user.id).delete_all
    redirect_to notifications_path
  end
end
