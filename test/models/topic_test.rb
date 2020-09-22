require "test_helper"

describe Topic do
  setup do
    @api_data = {
      "base_path" => "/topic/business-tax/paye",
      "content_id" => "uuid-23",
      "title" => "PAYE",
      "description" => "Pay As You Earn",
      "details" => {
      },
      "links" => {
        "parent" => [{
          "title" => "Business tax",
          "base_path" => "/topic/business-tax",
          "description" => "All about tax for businesses",
        }],
      },
    }
    @content_item = ContentItem.new(@api_data)
    @topic = Topic.new(@content_item)
  end

  describe "basic properties" do
    it "returns the topic base_path" do
      assert_equal "/topic/business-tax/paye", @topic.base_path
    end

    it "returns the topic title" do
      assert_equal "PAYE", @topic.title
    end

    it "returns the topic content ID" do
      assert_equal "uuid-23", @topic.content_id
    end

    it "returns the topic description" do
      assert_equal "Pay As You Earn", @topic.description
    end
  end

  describe "parent" do
    it "returns the parent title" do
      assert_equal "Business tax", @topic.parent.title
    end

    it "returns the parent base_path" do
      assert_equal "/topic/business-tax", @topic.parent.base_path
    end

    it "returns the combined_title" do
      assert_equal "Business tax: PAYE - detailed information", @topic.combined_title
    end

    describe "when parent details are missing" do
      # This should never happen, but it's still good to make this defensive
      setup do
        @api_data["links"].delete("parent")
      end

      it "returns nil for parent" do
        assert_nil @topic.parent
      end

      it "returns the topic title in combined_title" do
        assert_equal "PAYE: detailed information", @topic.combined_title
      end

      it "handles the links hash missing completely" do
        @api_data.delete("links")
        assert_nil @topic.parent
      end
    end
  end

  describe "children" do
    it "returns the title and base_path for all children" do
      @api_data["links"]["children"] = [
        {
          "title" => "Foo",
          "base_path" => "/topic/business-tax/foo",
        },
        {
          "title" => "Bar",
          "base_path" => "/topic/business-tax/bar",
        },
      ]

      assert_equal "Bar", @topic.children[0].title
      assert_equal "Foo", @topic.children[1].title
    end

    it "returns empty array with no children" do
      assert_equal [], @topic.children
    end

    it "returns empty array when the links field is missing" do
      @api_data.delete("links")
      assert_equal [], @topic.children
    end
  end

  describe "slug" do
    it "returns the slug for a subtopic" do
      @api_data["base_path"] = "/topic/business-tax/paye"
      assert_equal "business-tax/paye", @topic.slug
    end

    it "returns the slug for a top-level topic" do
      @api_data["base_path"] = "/topic/business-tax"
      assert_equal "business-tax", @topic.slug
    end
  end

  describe "lists" do
    it "passes the slug of the topic when constructing groups" do
      ListSet.expects(:new).with("specialist_sector", @content_item.content_id, anything).returns(:a_lists_instance)

      assert_equal :a_lists_instance, @topic.lists
    end

    it "passes the groups data when constructing" do
      ListSet.expects(:new).with(anything, anything, :some_data).returns(:a_lists_instance)
      @api_data["details"]["groups"] = :some_data

      assert_equal :a_lists_instance, @topic.lists
    end
  end

  describe "changed_documents" do
    setup do
      @content_item = ContentItem.new(@api_data)
      @topic = Topic.new(@content_item, foo: "bar")
    end

    it "passes the content id of the topic when constructing changed_documents" do
      Topic::ChangedDocuments
        .expects(:new)
        .with(@content_item.content_id, anything)
        .returns(:an_instance)
      assert_equal :an_instance, @topic.changed_documents
    end

    it "passes the pagination options when constructing changed_documents" do
      Topic::ChangedDocuments.expects(:new).with(anything, foo: "bar").returns(:an_instance)
      assert_equal :an_instance, @topic.changed_documents
    end
  end
end
