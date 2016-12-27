class Comment < ApplicationRecord
  include Publishable

  belongs_to :status

  validates :content, presence: true, length: 1..500
end
