##
# Relation 类，polymorphic，user 对 其他一切可 relationable 的关系，比如 user， project， status，
# publication， comment 等，只要能发生关系
class Relation < ApplicationRecord
  NAMES = {follow: "关注", like: "喜欢"}
  enum name: NAMES.keys

  belongs_to :user
  belongs_to :relationable, polymorphic: true

  has_many :statuses

  # 判断是否有关系
  def self.relation?(user, relation_name, relationable)
    where(user: user, name: relation_name, relationable: relationable).present?
  end

  # 获得关系
  def self.get_relation(user, relation_name, relationable)
    where(user: user, name: relation_name, relationable: relationable).take
  end
end
