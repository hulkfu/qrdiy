class ImageArray < ApplicationRecord
  include Publishable

  mount_uploaders :image_array, ImageUploader

  # before validates
  auto_strip_attributes :content,
                        squish: true

  validates :content, length: { maximum: 2000 }
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
    self.file_types[index] = file.content_type
    self.file_sizes[index] = file.size
    self.file_names[index] = file.original_filename
  end
end
