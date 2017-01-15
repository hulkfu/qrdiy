##
# Contentable，有内容的，能处理内容的。
# 之后会用 html pipeline 对内容进行处理。
# 它们都有：content, content_html。content_html 是 content 处理后得到的
# 有: Publication, Comment
#
module Contentable
  extend ActiveSupport::Concern

  included do
    after_create :generate_content_html
  end

  def content_type
    raise NotImplementedError, "Including classes must implement a content_type() method"
  end

  def generate_content_html
    # TODO content_html 存的是经过 html_pipline 处理后的代码：把 @，链接等 标示出来
    update_attributes(content_html: self.content)
  end
end
