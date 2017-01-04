##
# Comment 只是是对 status 的评论。而 status 包含了所有的状态。
# 如此结果了对多个东西进行评论的问题。
# Comment 需要独立吗？
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
