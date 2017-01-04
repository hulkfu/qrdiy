##
# Publication 类，多态成publishable，代表可以发布的东西：Attachment, Idea, Image, Plan
# 用来在 status 里显示。一个 publishable 可以有多个 statuses，比如 创建，修改等
#
class Publication < ApplicationRecord
  include Statusable
  include Relationable

  PUBLISHABLE_TYPE_NAMES = {idea: "想法", image_array: "图片", attachment: "文件",
    comment: "评论", message: "私信"}.freeze
  REPLIES_TYPE_NAMES = PUBLISHABLE_TYPE_NAMES.except(:comment, :message).freeze

  belongs_to :user
  belongs_to :project

  belongs_to :publishable, polymorphic: true

  after_create :generate_content_html

  # 默认最新的在前
  default_scope { order(created_at: :desc) }

  scope :without_comments, -> { where.not(publishable_type: "Comment")}

  def name
    PUBLISHABLE_TYPE_NAMES[publishable_type.underscore.to_sym]
  end

  def comment?
    publishable_type == "Comment"
  end

  def status_action_type
    comment? ? "comment" : "publication"
  end

  def generate_content_html
    # TODO content_html 存的是经过 html_pipline 处理后的代码：把 @，链接等 标示出来
    update_attributes(content_html: publishable.content)
  end

  # 创建 publishable，并关联创建其 publication
  # 比如：publication = Publication.create_publishable("idea", {content: "okok"}, {user_id:1, project_id: 1})
  def self.create_publishable!(publishable_type, publishable_params={}, publication_params={})
    Publication.transaction do
      publishable = publishable_type.classify.constantize.create!(publishable_params)
      publication = publishable.create_publication!(publication_params)
      return publishable
    end
  end
end
