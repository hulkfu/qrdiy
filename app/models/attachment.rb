class Attachment < ApplicationRecord
  has_one :publication, as: :publishable
end
