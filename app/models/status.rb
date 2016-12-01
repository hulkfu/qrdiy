##
# Status 类，记录事件流，一个 statusable 多态类，has_many 了它，边能够记录 status，代表可以有状态的
# 东西，比如 Idea 被 user 在 project 里发布后，就会创建一个 status，然后能够显示在 user 和
# project 的动态列表里。也可以是 user follow 了另一个 user。
class Status < ApplicationRecord

  belongs_to :statusable, polymorphic: true

  belongs_to :project
  belongs_to :user

  enum action_type: [:add, :change, :remove, :finish, :wait]

end
