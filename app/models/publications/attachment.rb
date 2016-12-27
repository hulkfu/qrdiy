class Attachment < ApplicationRecord
  include Publishable

  mount_uploader :attachment, AttachmentUploader

  validates :attachment, :presence => true,
            :file_size => { :less_than => 10.megabytes.to_i }

  # TODO 删除验证失败的文件

  before_save :set_attachment_attributes

  def set_attachment_attributes
    if attachment.present? && attachment_changed?
      self.file_type = attachment.file.content_type
      self.file_size = attachment.file.size
      self.file_name = attachment.file.original_filename
    end
  end
end
