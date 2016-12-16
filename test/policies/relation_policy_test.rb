require_relative 'policy_test_helper'

class RelationPolicyTest < PolicyTest

  def test_scope
  end

  def test_create
    u1 = User.create(id:1)
    # 自己喜欢自己
    relation = Relation.new(user: u1, name: "like", relationable: u1)
    assert permit(u1, relation, :create)

    relation.save
    relation = Relation.new(user: u1, name: "like", relationable: u1)
    # 只能喜欢一次
    assert forbid(u1, relation, :create)
  end

end
