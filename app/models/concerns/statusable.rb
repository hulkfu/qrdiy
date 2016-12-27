##
# 可以发布状态。
# 目前有： Project, Relation, Publication
module Statusable
  extend ActiveSupport::Concern

  included do
    has_many :statuses, as: :statusable
    after_create :create_status
  end

  def create_status
    # FIXME 不显示 trix create attachment
    # message 也没有 project_id
    if user_id
      status = statuses.new(user_id: user_id,
        action_type: try(:status_action_type) || "add")  # 判断是否定义了 action_type 方法
      status.project_id = try(:project_id)
      status.save!
    end
  end
end
