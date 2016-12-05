class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  # Download attachment
  def show
    @attachment = Attachment.find(params[:id])
    send_file File.join(Rails.root, 'public', @attachment.attachment_url),
              filename: @attachment.file_name,
              type: @attachment.content_type
  end

end
