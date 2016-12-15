class RelationPolicy < ApplicationPolicy

  def create?
    super
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
