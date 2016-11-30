class Status < ApplicationRecord

  belongs_to :statusable, polymorphic: true
  belongs_to :project
  belongs_to :user

  enum action_type: [:add, :change, :remove, :finish, :wait]
end
