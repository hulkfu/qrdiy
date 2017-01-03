class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :destroy]

  # TODO: 处理 status 的锚点跳转
  def show
    statusable = @status.statusable
    case statusable
    when Relation
      case statusable.relationable
      when Project, User
        redirect_to statusable.relationable
      end
    end
    render_404
  end

  def index
    @statuses = Status.all
  end

  def destroy
    authorize @status
    @status.destroy

    redirect_to :back
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end
end
