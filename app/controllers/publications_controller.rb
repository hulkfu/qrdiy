##
# Idea, ImageArray, Attachment 等的统一的 Controller
#
class PublicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_publication, only: [:show, :destroy]

  def new
    @type = params[:type]
  end

  def create
    begin
      if params[:project_id].present?
        @project = Project.find(params[:project_id])
        @publication = Publication.create_publishable!(params[:publishable_type],
          publishable_params,
          {user: current_user, project: @project})
        redirect_to @project, notice: "发布成功！"
      end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to @project, alert: "#{e.message}."
    end
  end

  # 预览图片，下载附件
  # TODO: 没有登录的情况，登录后的跳转
  def show
    case @publishable
    when ImageArray
      if params[:index].present?
        @index = params[:index].to_i
        @image = @publishable.image_array[@index]
        @image_name = @publishable.file_names[@index]
        render :preview
      end
    when Attachment
      send_file(File.join(Rails.root, 'public', @publishable.attachment_url),
        filename: @publishable.file_name, type: @publishable.file_type)
    else
      render_404
    end
  end

  # TODO: 可以合到 create 里，用参数区分
  # 给 trix ajax POST 附件
  def trix_attachment
    a = Publication.create_publishable!("attachment", {attachment: params[:file]}, {user: current_user})
    render json: {id: a.id, url: a.attachment.url}.to_json
  end

  # DELETE /publications/1
  # DELETE /publications/1.json
  def destroy
    # TODO soft destroy
    # @publication.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def set_publication
      @publication = Publication.find(params[:id])
      authorize @publication
      @publishable = @publication.publishable
    end

    def publishable_params
      params.require(:publishable).permit(:attachment, {image_array: []}, :content)
    end

    # def set_publishable
    #   params.each do |name, value|  # 查找表单里的内容
    #     if name =~ /(.+)_id$/ # 比如是，photo_id
    #       @publishable = $1.classify.constantize.find(value) # value 就是phote的id
    #     end
    #   end
    # end
end
