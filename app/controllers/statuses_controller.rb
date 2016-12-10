class StatusesController < ApplicationController
  before_action :set_status, only: [:destroy]

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
