##
# Publication 类，多态成publishable，代表可以发布的东西：Attachment, Idea, Image, Plan
# 用来在 status 里显示。一个 publishable 可以有多个 statuses，比如 创建，修改等
#
class Publication < ApplicationRecord
  has_many :statuses, as: :statusable

  belongs_to :user
  belongs_to :project

  belongs_to :publishable, polymorphic: true
end
