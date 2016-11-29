class Project < ApplicationRecord
  belongs_to :user

  # 用来查找 project 所有的 events
  has_many :all_events, class_name: :Event
  # 项目也有很多事件，比如创建。当项目不在时，也还是算用户的，需要在其也没显示，只是项目名标识一下
  has_many :events, as: :eventable
end
