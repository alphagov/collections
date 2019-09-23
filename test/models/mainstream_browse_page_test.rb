require "test_helper"

describe MainstreamBrowsePage do
  setup do
    @api_data = {
      "content_id" => "f818b54c-01c7-43e9-8165-cec12e4053ff",
      "base_path" => "/browse/benefits/child",
      "title" => "Child Benefit",
      "description" => "Information about eligibility, claiming and when Child Benefit stops",
      "details" => {
      },
      "links" => {
      },
    }
    @content_item = ContentItem.new(@api_data)
    @page = MainstreamBrowsePage.new(@content_item)
  end

  describe "basic properties" do
    it "returns the browse page content_id" do
      assert_equal "f818b54c-01c7-43e9-8165-cec12e4053ff", @page.content_id
    end

    it "returns the browse page base_path" do
      assert_equal "/browse/benefits/child", @page.base_path
    end

    it "returns the browse page title" do
      assert_equal "Child Benefit", @page.title
    end

    it "returns the browse page description" do
      assert_equal "Information about eligibility, claiming and when Child Benefit stops", @page.description
    end

    describe "#second_level_pages_curated?" do
      it "is true when second_level_ordering == curated" do
        @api_data["details"]["second_level_ordering"] = "curated"
        assert @page.second_level_pages_curated?
      end

      it "is false when second_level_ordering == alphabetical" do
        @api_data["details"]["second_level_ordering"] = "alphabetical"
        refute @page.second_level_pages_curated?
      end

      it "is false when second_level_ordering is unspecified" do
        @api_data["details"] = {}
        refute @page.second_level_pages_curated?
      end

      it "is false when details hash is missing" do
        @api_data.delete("details")
        refute @page.second_level_pages_curated?
      end
    end

    describe "#second_level_browse_pages" do
      before do
        @second_level_browse_page1 = {
          "content_id" => "1",
          "title" => "Foo",
          "description" => "All about foo",
          "base_path" => "/browse/foo",
        }
        @second_level_browse_page2 = {
          "content_id" => "2",
          "title" => "Bar",
          "description" => "All about bar",
          "base_path" => "/browse/bar",
        }
        @api_data["details"]["ordered_second_level_browse_pages"] = %w(1 2)
        @api_data["links"]["second_level_browse_pages"] = [
          @second_level_browse_page2,
          @second_level_browse_page1,
        ]
      end

      it "returns a curated set of links when second_level_ordering == curated" do
        @api_data["details"]["second_level_ordering"] = "curated"
        assert_equal [
          @second_level_browse_page1["content_id"],
          @second_level_browse_page2["content_id"],
        ], @page.second_level_browse_pages.map(&:content_id)
      end

      it "returns an alphabetically ordered set of links when second_level_ordering == alphabetical" do
        @api_data["details"]["second_level_ordering"] = "alphabetical"
        assert_equal [
          @second_level_browse_page2["content_id"],
          @second_level_browse_page1["content_id"],
        ], @page.second_level_browse_pages.map(&:content_id)
      end
    end
  end

  %w(
    top_level_browse_pages
    second_level_browse_pages
  ).each do |link_type|
    describe link_type do
      it "returns the title, base_path and description for all linked items" do
        @api_data["links"][link_type] = [
          {
            "title" => "Foo",
            "description" => "All about foo",
            "base_path" => "/browse/foo",
          },
          {
            "title" => "Bar",
            "description" => "All about bar",
            "base_path" => "/browse/bar",
          },
        ]

        items = @page.public_send(link_type)

        assert_equal "Bar", items[0].title
        assert_equal "All about bar", items[0].description
        assert_equal "/browse/bar", items[0].base_path

        assert_equal "Foo", items[1].title
        assert_equal "All about foo", items[1].description
        assert_equal "/browse/foo", items[1].base_path
      end

      it "returns empty array with no items" do
        assert_equal [], @page.public_send(link_type)
      end

      it "returns empty array when the links field is missing" do
        @api_data.delete("links")
        assert_equal [], @page.public_send(link_type)
      end
    end
  end

  it "filters items without title" do
    @api_data["links"]["second_level_browse_pages"] = [
      {
        "description" => "All about foo",
        "base_path" => "/browse/foo",
      },
      {
        "title" => "Bar",
        "description" => "All about bar",
        "base_path" => "/browse/bar",
      },
    ]

    items = @page.second_level_browse_pages

    assert_equal "Bar", items[0].title
    assert_equal "All about bar", items[0].description
    assert_equal "/browse/bar", items[0].base_path
  end

  describe "active_top_level_browse_page" do
    it "returns the title, base_path and description for the linked item" do
      @api_data["links"]["active_top_level_browse_page"] = [{
        "title" => "Foo",
        "description" => "All about foo",
        "base_path" => "/browse/foo",
      }]

      assert_equal "Foo", @page.active_top_level_browse_page.title
      assert_equal "/browse/foo", @page.active_top_level_browse_page.base_path
      assert_equal "All about foo", @page.active_top_level_browse_page.description
    end

    it "returns nil with no items" do
      assert_nil @page.active_top_level_browse_page
    end

    it "returns nil when the links field is missing" do
      @api_data.delete("links")
      assert_nil @page.active_top_level_browse_page
    end
  end

  describe "related_topics" do
    it "returns the title, base_path and description for all related topics" do
      @api_data["links"]["related_topics"] = [
        {
          "title" => "Foo",
          "description" => "All about foo",
          "base_path" => "/browse/foo",
        },
        {
          "title" => "Bar",
          "description" => "All about bar",
          "base_path" => "/browse/bar",
        },
      ]

      assert_equal "Foo", @page.related_topics[1].title
      assert_equal "/browse/bar", @page.related_topics[0].base_path
      assert_equal "All about foo", @page.related_topics[1].description
    end

    it "returns related topics alphabetised" do
      @api_data["links"]["related_topics"] = [
        {
          "title" => "Foo",
        },
        {
          "title" => "Bar",
        },
      ]

      assert_equal %w(Bar Foo), @page.related_topics.map(&:title)
    end

    it "returns empty array with no items" do
      assert_equal [], @page.related_topics
    end

    it "returns empty array when the links field is missing" do
      @api_data.delete("links")
      assert_equal [], @page.related_topics
    end
  end

  describe "slug" do
    it "returns the slug for a top-level browse page" do
      @api_data["base_path"] = "/browse/benefits"
      assert_equal "benefits", @page.slug
    end

    it "returns the slug for a child browse page" do
      @api_data["base_path"] = "/browse/benefits/child"
      assert_equal "benefits/child", @page.slug
    end
  end

  describe "lists" do
    it "should pass the content id of the browse page when constructing groups" do
      ListSet.expects(:new).with("section", @content_item.content_id, anything).returns(:a_lists_instance)

      assert_equal :a_lists_instance, @page.lists
    end

    it "should pass the groups data when constructing" do
      ListSet.expects(:new).with(anything, anything, :some_data).returns(:a_lists_instance)
      @api_data["details"]["groups"] = :some_data

      assert_equal :a_lists_instance, @page.lists
    end

    it "should pass in nil if the data is missing" do
      ListSet.expects(:new).with(anything, anything, nil).returns(:a_lists_instance)
      @api_data.delete("details")

      assert_equal :a_lists_instance, @page.lists
    end
  end
end
