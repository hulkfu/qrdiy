class RelationPolicy < ApplicationPolicy

  def create?
    # 不能重复发生关系
    return false if Relation.where(record.attributes.except("id", "created_at", "updated_at")).present?
    # 对于status 的 statusable 是关系的，不能再发生关系
    return false if record.is_a?(Status) && record.statusable.is_a?(Relation)

    true
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
