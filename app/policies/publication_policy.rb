class PublicationPolicy < ApplicationPolicy
  def show?
    user.present? and super
  end

  # TODO 只有在自己的项目里发布内容
  # TODO 越来越觉得 comment 需要移走,完全不是一路的,每次都要例外.
  def create?
    user == record.project.user
  end
end
