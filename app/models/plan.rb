class Plan < ApplicationRecord
  has_one :publication, as: :publishable
end
