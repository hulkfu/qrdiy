class Idea < ApplicationRecord
  include Publishable

  # before validates
  auto_strip_attributes :content,
                        squish: true

  validates :content, presence: true, length: 1..20000
end
