class Idea < ApplicationRecord
  has_one :publication, as: :publishable
end
