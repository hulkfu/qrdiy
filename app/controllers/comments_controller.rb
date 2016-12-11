class CommentsController < ApplicationController

  def create
    @status = Status.find(params[:status_id])
    Publication.create_publishable!("comment", {status: @status },
      {content: params[:comment][:content], user: current_user, project: @status.project})

    redirect_to @status.project

  end

  private

    def comment_params

    end
end
