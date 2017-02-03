class StatisticPolicy < ApplicationPolicy
  def index?
    user && user.admin?
  end
end
