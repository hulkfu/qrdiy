module Publishable
  extend ActiveSupport::Concern

  included do
    has_one :publication, as: :publishable

    # 映射 Publication 的关系，这样就不用每次先输入 publication 了
    %w(user project statuses content_html).each do |m|
      define_method m do
        publication.__send__ m
      end
    end
  end

  class_methods do

  end
end
