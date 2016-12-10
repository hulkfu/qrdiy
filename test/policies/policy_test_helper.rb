require 'test_helper'

class PolicyTest < ActiveSupport::TestCase
  def permit(current_user, record, action)
    self.class.to_s.gsub(/Test/, '').constantize.new(current_user, record).public_send("#{action.to_s}?")
  end

  def forbid(current_user, record, action)
    !permit(current_user, record, action)
  end

end
