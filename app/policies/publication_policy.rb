class PublicationPolicy < ApplicationPolicy
  def show?
    user.present? and super
  end

  # 只有在自己的项目里发布内容
  def create?
    user == record.project.user
  end
end
