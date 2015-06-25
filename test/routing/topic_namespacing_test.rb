require 'test_helper'

class TopicRoutingTest < ActionDispatch::IntegrationTest
  it "routes to the topic show page" do
    assert_recognizes({
      controller: 'topics',
      action: 'show',
      topic_slug: 'foo-topic',
    }, '/topic/foo-topic')
  end

  it "routes to the subtopic show page" do
    assert_recognizes({
      controller: 'subtopics',
      action: 'show',
      topic_slug: 'foo-topic',
      subtopic_slug: 'bar-topic',
    }, '/topic/foo-topic/bar-topic')
  end

  it "routes to the subtopic latest page" do
    assert_recognizes({
      controller: 'subtopics',
      action: 'latest_changes',
      topic_slug: 'foo-topic',
      subtopic_slug: 'bar-topic',
    }, '/topic/foo-topic/bar-topic/latest')
  end

  it "routes to the subtopic email signup page" do
    assert_recognizes({
      controller: 'email_signups',
      action: 'new',
      topic_slug: 'foo-topic',
      subtopic_slug: 'bar-topic',
    }, '/topic/foo-topic/bar-topic/email-signup')
  end
end
