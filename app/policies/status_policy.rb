class StatusPolicy < ApplicationPolicy

  def destroy?
    super
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
