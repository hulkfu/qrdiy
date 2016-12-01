##
# Publication 类，多态成publishable，代表可以发布的东西：Attachment, Idea, Image, Plan
# 用来在 status 里显示。一个 publishable 可以有多个 statuses，比如 创建，修改等
#
class Publication < ApplicationRecord
  has_many :statuses, as: :statusable

  belongs_to :user
  belongs_to :project

  belongs_to :publishable, polymorphic: true

  after_create :create_status

  def create_status
    statuses.create(user_id: user_id, project_id: project_id, action_type: "add")
  end

  # 创建 publishable，并关联创建其 publication
  def self.create_publishable(publishable_type, publishable_params={}, publication_params={})
    publishable = publishable_type.classify.constantize.create(publishable_params)
    publication_params[:content_html] = publishable.content
    publishable.create_publication(publication_params)
  end
end
