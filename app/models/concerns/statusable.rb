##
# 可以发布状态。
# 目前有： Project, Relation, Publication, Comment
module Statusable
  extend ActiveSupport::Concern

  included do
    has_many :statuses, as: :statusable, dependent: :destroy
    after_create :create_status
  end

  def status_action_type
    raise NotImplementedError, "Including classes must implement a status_action_type() method"
  end

  def create_status
    # TODO message 也没有 project
    if user_id
      # 不是创建 projet 也没有 project 的 不生成 status
      # 即不显示 trix create attachment
      return if project.nil? && status_action_type != "project"
      status = statuses.new(user_id: user_id,
        action_type: status_action_type)  # 判断是否定义了 action_type 方法
      status.project = try(:project)
      status.save!
    end
  end
end
