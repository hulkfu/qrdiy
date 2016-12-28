##
# Relation 类，polymorphic，user 对 其他一切可 relationable 的关系，比如 user， project， status，
# publication， comment 等，只要能发生关系
class Relation < ApplicationRecord
  include Statusable

  ACTION_TYPE_NAMES = {follow: "关注", like: "喜欢", praise: "赞"}.freeze
  ACTION_TYPES = ACTION_TYPE_NAMES.keys
  enum action_type: ACTION_TYPES

  belongs_to :user
  belongs_to :relationable, polymorphic: true

  # 可以和自己或自己的东西发生关系，但是就不用在生成新的 status 了
  skip_callback :create, :after, :create_status, if: -> { user == relationable_user}

  # 为 Status 定义获得 action 的方法，在 statusable 里被调用
  def status_action_type
    action_type
  end

  # relaitonable 的 user
  def relationable_user
    if relationable_type == "User"
      relationable
    else  # project, publication
      relationable.user
    end
  end

  def action_name
    ACTION_TYPE_NAMES[action_type.to_sym]
  end

  def desc
    action_name
  end

  class << self
    # 判断是否有关系
    def relation?(user, action_type, relationable)
      where(user: user, action_type: action_type, relationable: relationable).present?
    end

    # 获得关系
    def get_relation(user, action_type, relationable)
      where(user: user, action_type: action_type, relationable: relationable).take
    end
  end

end
