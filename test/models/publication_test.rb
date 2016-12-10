require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  test "Publication create ides publishable" do
    idea = Publication.create_publishable!("idea", {content: "okok"}, {user: users(:user1), project: projects(:project1)})

    assert idea
    assert_equal idea.content, "okok"

    publication = idea.publication
    assert_equal publication.publishable_type, "Idea"
    status = publication.statuses.first
    assert_equal status.action_type, "add"
  end
end
