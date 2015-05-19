require 'test_helper'
require 'ostruct'

describe TopicPresenter do
  describe "a topic called Oil and gas" do
    setup do
      @topic = OpenStruct.new(title: "Oil and gas")
    end

    it "strip the topic title from the artefact title" do
      artefact = OpenStruct.new(title: "Oil and gas: Wells and fields")
      topic = TopicPresenter.new(artefact, @topic)
      assert_equal "Wells and fields", topic.title
    end

    it "upcase the first character of the remaining part of the artefact title" do
      artefact = OpenStruct.new(title: "Oil and gas: taxes")
      topic = TopicPresenter.new(artefact, @topic)
      assert_equal "Taxes", topic.title
    end

    it "leave a non-matching artefact title intact" do
      artefact = OpenStruct.new(title: "a page about something else")
      topic = TopicPresenter.new(artefact, @topic)
      assert_equal "a page about something else", topic.title
    end

    it "only match the topic title at the beginning of the artefact title" do
      artefact = OpenStruct.new(title: "Also about Oil and Gas: Wells")
      topic = TopicPresenter.new(artefact, @topic)
      assert_equal "Also about Oil and Gas: Wells", topic.title
    end
  end
end
