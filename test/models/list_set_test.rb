require "test_helper"

describe ListSet do
  describe "for a curated subtopic" do
    setup do
      @group_data = [
        {
          "name" => "Paying HMRC",
          "contents" => [
           '/pay-paye-tax',
           '/pay-psa',
           '/pay-paye-penalty',
          ]
        },
        {
          "name" => "Annual PAYE and payroll tasks",
          "contents" => [
           '/payroll-annual-reporting',
           '/get-paye-forms-p45-p60',
           '/employee-tax-codes',
          ]
        },
      ]

      topic_links = [
        ContentItem.new("title" => "Employee tax codes", "base_path" => "/employee-tax-codes"),
        ContentItem.new("title" => "Get PAYE forms P45 P60", "base_path" => "/get-paye-forms-p45-p60"),
        ContentItem.new("title" => "Pay PAYE penalty", "base_path" => "/pay-paye-penalty"),
        ContentItem.new("title" => "Pay PAYE tax", "base_path" => "/pay-paye-tax"),
        ContentItem.new("title" => "Pay PSA", "base_path" => "/pay-psa"),
        ContentItem.new("title" => "Payroll annlual reporting", "base_path" => "/payroll-annual-reporting"),
      ]

      @list_set = ListSet.new(topic_links, @group_data)
    end

    it "returns the groups in the curated order" do
      assert_equal ["Paying HMRC", "Annual PAYE and payroll tasks"], @list_set.map(&:title)
    end

    it "provides the title and base_path for group items" do
      groups = @list_set.to_a

      assert_equal "Employee tax codes", groups[1].contents.to_a[2].title
      assert_equal "/pay-psa", groups[0].contents.to_a[1].base_path
    end

    it "skips items no longer tagged to this subtopic" do
      @group_data[0]["contents"] << "/pay-bear-tax"

      groups = @list_set.to_a
      assert_equal 3, groups[0].contents.size
      refute groups[0]["contents"].map(&:base_path).include?("/pay-bear-tax")
    end

    it "omits groups with no active items in them" do
      @group_data << {
        "name" => "Group with untagged items",
        "contents" => [
          "/pay-bear-tax",
        ],
      }
      @group_data << {
        "name" => "Empty group",
        "contents" => [],
      }

      assert_equal 2, @list_set.count
      list_titles = @list_set.map(&:title)
      refute list_titles.include?("Group with untagged items")
      refute list_titles.include?("Empty group")
    end

    it "returns no groups if there is no linked content" do
      list_set = ListSet.new(nil, @group_data)

      assert_equal 0, list_set.count
    end
  end

  describe "for a non-curated topic" do
    it "constructs a single A-Z group" do
      list_set = ListSet.new([], [])

      assert_equal 1, list_set.to_a.size
      assert_equal "A to Z", list_set.first.title
    end

    it "constructs a single A-Z group if group array is nil" do
      list_set = ListSet.new([], nil)

      assert_equal 1, list_set.to_a.size
      assert_equal "A to Z", list_set.first.title
    end

    it "returns an empty A-Z group is no linked content" do
      list_set = ListSet.new(nil, [])

      assert_equal 1, list_set.to_a.size
      assert_equal "A to Z", list_set.first.title
      assert_equal 0, list_set.first.contents.size
    end

    it "includes content tagged to the topic in alphabetical order" do
      topic_links = [
        ContentItem.new("title" => "Pay PAYE tax"),
        ContentItem.new("title" => "Get PAYE forms P45 P60"),
        ContentItem.new("title" => "Pay PAYE penalty"),
        ContentItem.new("title" => "Employee tax codes"),
      ]
      list_set = ListSet.new(topic_links, [])

      expected_titles = [
        "Employee tax codes",
        "Get PAYE forms P45 P60",
        "Pay PAYE penalty",
        "Pay PAYE tax",
      ]
      assert_equal expected_titles, list_set.first.contents.map(&:title)
    end

    it "includes the base_path" do
      topic_links = [
        ContentItem.new("base_path" => "/some/base/path"),
      ]

      list_set = ListSet.new(topic_links, [])

      assert_equal "/some/base/path", list_set.first.contents.first.base_path
    end
  end

  describe "filtering uncurated lists" do
    it "shouldn't display a document if its format is excluded" do
      topic_links = [
        ContentItem.new(
          "title" => "Living abroad",
          "base_path" => "/living-abroad",
          "document_type" => "some-excluded-doc-type")
      ]
      excluded_document_types = ["some-excluded-doc-type"]

      list_set = ListSet.new(topic_links, [], excluded_document_types)

      assert_equal 0, list_set.first.contents.length
    end

    it "should display a document if its format isn't excluded" do
      topic_links = [
        ContentItem.new(
          "title" => "Living abroad",
          "base_path" => "/living-abroad",
          "document_type" => "some-doc-type-not-excluded")
      ]
      excluded_document_types = []

      list_set = ListSet.new(topic_links, [], excluded_document_types)

      results = list_set.first.contents
      assert_equal 1, results.length
      assert_equal 'Living abroad', results.first.title
    end
  end

  describe "determining whether content is curated" do
    it "should identify content with groups as curated" do
      group_data = [
        {
          "name" => "Paying HMRC",
          "contents" => ['/pay-paye-tax']
        },
      ]

      list_set = ListSet.new([], group_data)

      assert list_set.curated?
    end

    it "should identify content with no groups as not curated" do
      list_set = ListSet.new([], [])

      assert_not list_set.curated?
    end

    it "should identify content with missing group data as not curated" do
      list_set = ListSet.new([], nil)

      assert_not list_set.curated?
    end
  end
end
