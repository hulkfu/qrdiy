##
# Contentable，有内容的，能处理内容的。
# 它们都有：content, content_html。content_html 是 content 处理后得到的
# 有: Publication, Comment
#
module Contentable
  extend ActiveSupport::Concern

  def content_type
    raise NotImplementedError, "Including classes must implement a content_type() method"
  end
end
