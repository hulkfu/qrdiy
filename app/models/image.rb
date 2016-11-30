class Image < ApplicationRecord
  has_one :publication, as: :publishable
end
