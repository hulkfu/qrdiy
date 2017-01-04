##
# Comment 只是是对 status 的评论。而 status 包含了所有的状态。
# 如此结果了对多个东西进行评论的问题。
#
# Comment 需要独立吗？
# 目前看不需要，因为虽然在 Publication 里处理主要逻辑，但该分离的已经分离了。
# 主要是可以按需求正常运行，没有必要独立。实在满足不了，需要独立的话。只需要
# 迁移数据库，并修改相关。工作量也不大。
#
class Comment < ApplicationRecord
  include Publishable

  belongs_to :status

  auto_strip_attributes :content,
                        squish: true, nullify: false
  validates :content, presence: true, length: 1..500

  def commentable
    status.statusable
  end
end
