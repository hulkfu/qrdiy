class Idea < ApplicationRecord
  include Publishable

  validates :content, presence: true, length: 1..20000
end
