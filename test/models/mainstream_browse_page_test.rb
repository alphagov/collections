require "test_helper"

describe MainstreamBrowsePage do
  setup do
    @api_data = {
      "base_path" => "/browse/benefits/child",
      "title" => "Child Benefit",
      "description" => "Information about eligibility, claiming and when Child Benefit stops",
      "details" => {
      },
      "links" => {
      },
    }
    @page = MainstreamBrowsePage.new(@api_data)
  end

  describe "basic properties" do
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
  end

  [
    "top_level_browse_pages",
    "second_level_browse_pages",
  ].each do |link_type|
    describe link_type do
      it "returns the title, base_path and description for all linked items" do
        @api_data["links"][link_type] = [
          {
            "title"=>"Foo",
            "description" => "All about foo",
            "base_path"=>"/browse/foo",
          },
          {
            "title"=>"Bar",
            "description" => "All about bar",
            "base_path"=>"/browse/bar",
          },
        ]

        items = @page.public_send(link_type)

        assert_equal 'Foo', items[0].title
        assert_equal '/browse/bar', items[1].base_path
        assert_equal 'All about foo', items[0].description
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

  describe "active_top_level_browse_page" do
    it "returns the title, base_path and description for the linked item" do
      @api_data["links"]["active_top_level_browse_page"] = [{
        "title"=>"Foo",
        "description" => "All about foo",
        "base_path"=>"/browse/foo",
      }]

      assert_equal 'Foo', @page.active_top_level_browse_page.title
      assert_equal '/browse/foo', @page.active_top_level_browse_page.base_path
      assert_equal 'All about foo', @page.active_top_level_browse_page.description
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
          "title"=>"Foo",
          "description" => "All about foo",
          "base_path"=>"/browse/foo",
        },
        {
          "title"=>"Bar",
          "description" => "All about bar",
          "base_path"=>"/browse/bar",
        },
      ]

      assert_equal 'Foo', @page.related_topics[0].title
      assert_equal '/browse/bar', @page.related_topics[1].base_path
      assert_equal 'All about foo', @page.related_topics[0].description
    end

    # FIXME: replace the describe below with these 2 tests when we no longer
    # need to support detailed guide categories from whitehall
    #it "returns empty array with no items" do
      #assert_equal [], @page.related_topics
    #end

    #it "returns empty array when the links field is missing" do
      #@api_data.delete("links")
      #assert_equal [], @page.related_topics
    #end

    describe "when there are no related_topics" do
      before do
        @original_whitehall = Collections.services(:detailed_guidance_content_api)
        @mock_whitehall = stub("whitehall")
        Collections.services(:detailed_guidance_content_api, @mock_whitehall)
      end
      after do
        Collections.services(:detailed_guidance_content_api, @original_whitehall)
      end

      it "returns guidance categories from whitehall" do
        @mock_whitehall.stubs(:sub_sections).returns(stubbed_whitehall_response(
          [{
            "title" => "From Whitehall",
            "content_with_tag" => {
              "web_url" => "/foo/bar/baz",
            },
          }]
        ))

        topics = @page.related_topics
        assert_equal 1, topics.size
        assert_equal "From Whitehall", topics.first.title
        assert_equal "/foo/bar/baz", topics.first.base_path
      end

      it "sorts the whitehall categories by title" do
        @mock_whitehall.stubs(:sub_sections).returns(stubbed_whitehall_response(
          [
            {"title" => "Bravo", "content_with_tag" => {"web_url" => "/foo"}},
            {"title" => "Alpha", "content_with_tag" => {"web_url" => "/foo"}},
            {"title" => "Charlie", "content_with_tag" => {"web_url" => "/foo"}},
          ]
        ))

        assert_equal ['Alpha', 'Bravo', 'Charlie'], @page.related_topics.map(&:title)
      end

      it "returns empty array when whitehall has no categories" do
        # Yes, whitehall returns a 404, not empty array when there are no categories...
        @mock_whitehall.stubs(:sub_sections).raises(GdsApi::HTTPNotFound.new("Not Found"))

        assert_equal [], @page.related_topics
      end
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
    it "should pass the contentapi slug of the browse page when constructing groups" do
      ListSet.expects(:new).with("section", "benefits/child", anything()).returns(:a_lists_instance)

      assert_equal :a_lists_instance, @page.lists
    end

    it "should pass the groups data when constructing" do
      ListSet.expects(:new).with(anything(), anything(), :some_data).returns(:a_lists_instance)
      @api_data["details"]["groups"] = :some_data

      assert_equal :a_lists_instance, @page.lists
    end

    it "should pass in nil if the data is missing" do
      ListSet.expects(:new).with(anything(), anything(), nil).returns(:a_lists_instance)
      @api_data.delete("details")

      assert_equal :a_lists_instance, @page.lists
    end
  end

  def stubbed_whitehall_response(results)
    build_ostruct_recursively(results: results)
  end
end
