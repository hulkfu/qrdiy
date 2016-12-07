##
# Idea, ImageArray, Attachment 等的统一的 Controller
#
class PublicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_publication

  def show
    if @publishable.respond_to? :image_array
      @index = params[:index].to_i
      @image = @publishable.image_array[@index]
    else
      render_404
    end
  end

  # Download attachment
  def download
    if @publishable.respond_to? :attachment_url
      send_file(File.join(Rails.root, 'public', @publishable.attachment_url),
        filename: @publishable.file_name, type: @publishable.content_type)
    else
      render_404
    end
  end


  private
    def set_publication
      @publication = Publication.find(params[:id])
      @publishable = @publication.publishable
    end

    # def set_publishable
    #   params.each do |name, value|  # 查找表单里的内容
    #     if name =~ /(.+)_id$/ # 比如是，photo_id
    #       @publishable = $1.classify.constantize.find(value) # value 就是phote的id
    #     end
    #   end
    # end
end
