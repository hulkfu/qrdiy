class Comment < ApplicationRecord
  has_one :publication, as: :publishable
  belongs_to :status
end
