module notificationable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :notificationable
  end
end
