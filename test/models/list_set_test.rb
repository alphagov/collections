require "test_helper"

describe ListSet do
  include RummagerHelpers

  describe "for a curated subtopic" do
    setup do
      @group_data = [
        {
          "name" => "Paying HMRC",
          "contents" => [
            contentapi_url_for_slug("pay-paye-tax"),
            contentapi_url_for_slug("pay-psa"),
            contentapi_url_for_slug("pay-paye-penalty"),
          ]
        },
        {
          "name" => "Annual PAYE and payroll tasks",
          "contents" => [
            contentapi_url_for_slug("payroll-annual-reporting"),
            contentapi_url_for_slug("get-paye-forms-p45-p60"),
            contentapi_url_for_slug("employee-tax-codes"),
          ]
        },
      ]

      rummager_has_documents_for_subtopic(
        "business-tax/paye",
        [
          "employee-tax-codes",
          "get-paye-forms-p45-p60",
          "pay-paye-penalty",
          "pay-paye-tax",
          "pay-psa",
          "payroll-annual-reporting",
        ],
        page_size: Topic::ContentTaggedToTopic::PAGE_SIZE_TO_GET_EVERYTHING
      )

      @list_set = ListSet.new("specialist_sector", "business-tax/paye", @group_data)
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
      @group_data[0]["contents"] << contentapi_url_for_slug("pay-bear-tax")

      groups = @list_set.to_a
      assert_equal 3, groups[0].contents.size
      refute groups[0]["contents"].map(&:base_path).include?("/pay-bear-tax")
    end

    it "omits groups with no active items in them" do
      @group_data << {
        "name" => "Group with untagged items",
        "contents" => [
          contentapi_url_for_slug("pay-bear-tax"),
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

    describe "handling base_paths in content-store curated lists data" do
      setup do
        @group_data[0]["contents"] = [
           '/pay-paye-tax',
           '/pay-psa',
           '/pay-paye-penalty',
        ]
        @group_data[1]["contents"] = [
           '/payroll-annual-reporting',
           '/get-paye-forms-p45-p60',
           '/employee-tax-codes',
        ]
      end

      it "matches up the content items correctly" do
        groups = @list_set.to_a

        assert_equal 2, groups.size
        assert_equal 3, groups[0].contents.size
        assert_equal 3, groups[1].contents.size
        assert_equal "Employee tax codes", groups[1].contents.to_a[2].title
        assert_equal "/pay-psa", groups[0].contents.to_a[1].base_path
      end
    end
  end

  describe "for a non-curated topic" do
    setup do
      rummager_has_documents_for_subtopic(
        "business-tax/paye",
        [
          "get-paye-forms-p45-p60",
          "pay-paye-penalty",
          "pay-paye-tax",
          "pay-psa",
          "employee-tax-codes",
          "payroll-annual-reporting",
        ],
        page_size: Topic::ContentTaggedToTopic::PAGE_SIZE_TO_GET_EVERYTHING
      )
      @list_set = ListSet.new("specialist_sector", "business-tax/paye", [])
    end

    it "constructs a single A-Z group" do
      assert_equal 1, @list_set.to_a.size
      assert_equal "A to Z", @list_set.first.title
    end

    it "includes content tagged to the topic in alphabetical order" do
      expected_titles = [
        "Employee tax codes",
        "Get paye forms p45 p60",
        "Pay paye penalty",
        "Pay paye tax",
        "Pay psa",
        "Payroll annual reporting"
      ]
      assert_equal expected_titles, @list_set.first.contents.map(&:title)
    end

    it "includes the base_path for all items" do
      assert_equal "/pay-paye-tax", @list_set.first.contents.to_a[3].base_path
    end

    it "handles nil data the same as empty array" do
      @list_set = ListSet.new("specialist_sector", "business-tax/paye", nil)
      assert_equal 1, @list_set.to_a.size
      assert_equal "A to Z", @list_set.first.title
    end
  end
end
