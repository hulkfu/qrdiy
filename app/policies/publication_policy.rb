class PublicationPolicy < ApplicationPolicy
  def show?
    user.present? and super
  end
end
