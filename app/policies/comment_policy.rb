class CommentPolicy < ApplicationPolicy
  ##
  # 不能对评论的 status 进行评论
  #
  def create?
    not (record.commentable.is_a?(Status) && record.commentable.statusable.is_a?(Comment))
  end
end
