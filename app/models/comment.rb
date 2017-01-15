##
# Comment 目前只是是对 status 的评论。而 status 包含了所有的状态。
# 如此结果了对多个东西进行评论的问题。
#
# 以后还能对其他评论，因为它是多态的。
#
# Comment 需要独立吗？已经独立了。
# 目前看不需要，因为虽然在 Publication 里处理主要逻辑，但该分离的已经分离了。
# 主要是可以按需求正常运行，没有必要独立。实在满足不了，需要独立的话。只需要
# 迁移数据库，并修改相关。工作量也不大。
#
# 已经独立! Publication 只是能在 Project 里发布的内容,是创造的内容!
# 做完后发现还是有些工作量的，不过这也是再说难免的，工程就是发现跟想的不一样。
class Comment < ApplicationRecord
  include Statusable    # 评论也会生成状态
  include Relationable
  include Contentable

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  auto_strip_attributes :content,
                        squish: true, nullify: false
  validates :content, presence: true, length: 1..500

  def project
    commentable.try(:project)
  end

  def status_action_type
    "comment"
  end

  def content_type
    "comment"
  end
end
