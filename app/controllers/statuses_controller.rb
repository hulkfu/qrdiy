class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :destroy]

  # 处理 status 的锚点跳转
  def show
    statusable = @status.statusable
    case statusable
    when Project
      redirect_to statusable
    when Relation
      case statusable.relationable
      when Project, User
        redirect_to statusable.relationable
      when Publication
        redirect_to_publication statusable.relationable
      end
    when Publication
      redirect_to_publication statusable
    end
  end

  def index
    @statuses = Status.all
  end

  def destroy
    @status.destroy

    redirect_to :back
  end

  private

  def set_status
    @status = Status.find(params[:id])
    authorize @status
  end

  # TODO: 跳转到 publication 的锚点，分辨出 comment
  def redirect_to_publication(publication)
    # 算出在 status 在 project show 的第几页
    project = @status.project
    redirect_to project_path(project,
      page: project.page_of_status(@status),
      anchor: "status-#{@status.id}")
  end
end
