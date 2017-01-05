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
      ##
      # 如果这个 relation 是和一个 status 发生的关系，那么回跳两次：
      # 1. 下面跳到 status 处。
      # 2. 再次来到 show 里，得到 status 的 statusable 后再跳，比如是个 publication。
      # 有些递归的意思，停止条件是：statusable 不再是 status。
      #  举个例子：我 like 了一个 发布图片的 status，因此会产生一个 like status，同时这个
      #     like status 会生成一个 notification 通知图片的发布者，而发布者能够通过点击
      #     notification 里的 link 跳到具体的图片 status。
      #     当发生时，首先解析 like status 的 show，发现是个 relation 而且 relationable
      #     是个 status，其实就是那个图片 status，会直接跳转到 图片 status 的 show，再解析
      #     发现 statusable 是个 Publication，于是就跳到图片的 status 了。
      # （趁现在还能记清赶快记下，之后又要分析 :p）
      #
      when Project, User, Status
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
