class Publication < ApplicationRecord
  belongs_to :user
  belongs_to :project

  belongs_to :publishable, polymorphic: true
  belongs_to :attachment
  belongs_to :idea
  belongs_to :image
  belongs_to :plan
end
