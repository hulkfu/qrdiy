class RelationPolicy < ApplicationPolicy

  def create?
    # 不能重复发生关系
    not Relation.where(record.attributes.except("id", "created_at", "updated_at")).present?
  end

  def destroy?
    super
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
