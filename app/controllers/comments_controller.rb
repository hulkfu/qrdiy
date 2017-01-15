class CommentsController < ApplicationController
  before_action :set_commentable, only: [:new, :create]
  before_action :set_comment, only: [:destroy]

  def new
  end

  def create
    @comment = Comment.create!(commentable: @commentable,
      content: params[:publishable][:content],
      user: current_user)
  end

  def destroy
    authorize @comment
    @comment.destroy
  end

  private
    # TODO 其他的 commentable，因为现在只对 status 评论
    # 对 用户的话就是留言了
    def set_commentable
      @commentable = Status.find(params[:status_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end
