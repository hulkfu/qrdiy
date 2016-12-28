module Relationable
  extend ActiveSupport::Concern

  included do
    has_many :relations, as: :relationable

    Relation::ACTION_TYPES.each do |action_type|
      # follow，like 等这个东西的用户
      define_method "who_#{action_type}" do
        User.where(id: relations.where(action_type: action_type).map(&:user_id))
      end
    end
  end

end
