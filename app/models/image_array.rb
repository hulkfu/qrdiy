class ImageArray < ApplicationRecord
  mount_uploaders :image_array, ImageUploader

  has_one :publication, as: :publishable

  validates :image_array, :presence => true,
            :file_size => { :less_than => 10.megabytes.to_i }

  # TODO 删除验证失败的文件

  before_save :set_image_array_attributes

  def set_image_array_attributes
    if image_array.present? && image_array_changed?
      image_array.each_with_index do |image, index|
        set_image_attributes image, index
      end
    end
  end

  def set_image_attributes(image, index)
    file = image.file
    self.content_types[index] = file.content_type
    self.file_sizes[index] = file.size
    self.file_names[index] = file.original_filename
  end
end
