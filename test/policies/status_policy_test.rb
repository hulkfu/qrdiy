require_relative 'policy_test_helper'

class StatusPolicyTest < PolicyTest

  def test_scope
  end

  def test_destroy
    user1 = users(:user1)
    status = Status.create(user: user1)
    assert permit(user1, status, :destroy)
    assert forbid(users(:user2), status, :destroy)
  end
end
