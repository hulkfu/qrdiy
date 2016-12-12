class Comment < ApplicationRecord
  include Publishable

  belongs_to :status
end
