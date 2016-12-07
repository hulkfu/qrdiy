class ImageArray < ApplicationRecord
  mount_uploaders :images, ImageUploader

  has_one :publication, as: :publishable
end
