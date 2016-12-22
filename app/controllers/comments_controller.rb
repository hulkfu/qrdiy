class CommentsController < ApplicationController
  before_action :set_status, only: [:new, :create]
  before_action :set_comment, only: [:destroy]

  def new
  end

  def create
    @comment = Publication.create_publishable!("comment", {status: @status },
      {content: params[:comment][:content], user: current_user, project: @status.project})
  end

  def destroy
    authorize @comment
    @comment.destroy
  end

  private
    def set_status
      @status = Status.find(params[:status_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end
