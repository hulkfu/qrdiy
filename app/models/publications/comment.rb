class Comment < ApplicationRecord
  include Publishable

  belongs_to :status

  auto_strip_attributes :content,
                        squish: true, nullify: false
  validates :content, presence: true, length: 1..500
end
