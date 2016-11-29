class Event < ApplicationRecord

  belongs_to :eventable, polymorphic: true
  belongs_to :project
  belongs_to :user

  enum action_type: [:add, :change, :remove, :finish, :wait]
end
