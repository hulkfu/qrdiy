##
# Publication 类，多态成publishable，代表可以发布的东西：Attachment, Idea, Image, Plan
# 用来在 status 里显示。一个 publishable 可以有多个 statuses，比如 创建，修改等
#
class Publication < ApplicationRecord
  PUBLISHABLE_TYPE_NAMES = {idea: "想法", image_array: "图片", attachment: "文件", comment: "评论"}

  validates :content, length: {maximum: 200}

  has_many :statuses, as: :statusable

  belongs_to :user
  belongs_to :project

  belongs_to :publishable, polymorphic: true

  after_create :create_status
  after_create :generate_content_html

  def create_status
    # 这样当给 trix create attachment 时，就不会创建 status 了，因子还没有 project
    if user_id && project_id
      statuses.create(user_id: user_id, project_id: project_id, action_type: "add")
    end
  end

  def generate_content_html
    # TODO content_html 存的是经过 html_pipline 处理后的代码：把 @，链接等 标示出来
    update_attributes(content_html: content)
  end

  # 创建 publishable，并关联创建其 publication
  # 比如：publication = Publication.create_publishable("idea", {}, {content: "okok", user_id:1, project_id: 1})
  def self.create_publishable!(publishable_type, publishable_params={}, publication_params={})
    self.transaction do
      publishable = publishable_type.classify.constantize.create!(publishable_params)
      publishable.create_publication(publication_params)
      return publishable
    end
  end
end
