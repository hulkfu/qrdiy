module Relationable
  extend ActiveSupport::Concern

  included do
    has_many :relations, as: :relationable

    Relation::NAMES.keys.each do |name|
      # follow，like 等这个东西的用户
      define_method "who_#{name}" do
        User.where(id: relations.where(name: name).map(&:user_id))
      end
    end
  end

end
