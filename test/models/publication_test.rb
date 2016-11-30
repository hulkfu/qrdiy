require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  test "Publication create ides publishable" do
    publication = Publication.create_publishable("idea", {content: "okok"}, {user_id:1, project_id: 1})
    assert_equal publication.publishable_type, "Idea"

    idea = publication.publishable
    assert idea
    assert_equal idea.content, "okok"

    status = publication.statuses.first
    assert_equal status.action_type, "add"
  end
end
