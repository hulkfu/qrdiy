class ImageArray < ApplicationRecord
  mount_uploaders :image_array, ImageUploader

  has_one :publication, as: :publishable
end
