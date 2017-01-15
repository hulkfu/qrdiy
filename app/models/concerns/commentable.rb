##
# Commentable, 能被评论的东西。
# 有： Status
#
module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end

end
