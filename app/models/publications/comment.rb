class Comment < ApplicationRecord
  include Publishable

  belongs_to :status

  # validates :content, presence: true, length: 10..500
end
