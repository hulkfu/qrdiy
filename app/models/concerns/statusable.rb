module Statusable
  extend ActiveSupport::Concern

  included do
    has_many :statuses, as: :statusable
  end
end
