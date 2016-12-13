##
# Relation 类，polymorphic，user 对 其他一切可 relationable 的关系，比如 user， project， status，
# publication， comment 等，只要能发生关系
class Relation < ApplicationRecord
  RELATION_NAMES = {follow: "关注", like: "喜欢"}
  enum relation: RELATION_NAMES.keys

  belongs_to :user
  belongs_to :relationable, polymorphic: true

  has_many :statuses

  scope :follow, where(relation: "follow")
  scope :like, where(relation: "like")


  private

    def relation_params
      params.require(:user_project_relation)
        .permit(:user_id, :relation, :relationable_id, :relationable_type)
    end
end
