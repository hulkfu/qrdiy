module Statusable
  extend ActiveSupport::Concern

  included do
    has_many :statuses, as: :statusable
    after_create :create_status
  end

  def create_status
    # FIXME 这样当给 trix create attachment 时，就不会创建 status 了，因子还没有 project
    # message 也没有 project_id
    if user_id && project_id
      statuses.create(user_id: user_id, project_id: project_id, action_type: "add")
    end
  end
end
