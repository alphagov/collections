require "test_helper"

describe Subtopic do
  setup do
    @api_data = {
      "base_path" => "/topic/business-tax/paye",
      "title" => "PAYE",
      "description" => "Pay As You Earn",
      "details" => {
      },
      "links" => {
        "parent" => [{
          "title"=>"Business tax",
          "base_path"=>"/topic/business-tax",
          "description"=>"All about tax for businesses",
        }],
      },
    }
    @subtopic = Subtopic.new(@api_data)
  end

  describe "basic properties" do
    it "returns the subtopic base_path" do
      assert_equal "/topic/business-tax/paye", @subtopic.base_path
    end

    it "returns the subtopic title" do
      assert_equal "PAYE", @subtopic.title
    end

    it "returns the subtopic description" do
      assert_equal "Pay As You Earn", @subtopic.description
    end

    it "returns the subtopic's beta status" do
      assert_equal false, @subtopic.beta?

      @api_data["details"]["beta"] = true
      assert_equal true, @subtopic.beta?
    end
  end

  describe "parent" do
    it "returns the parent title" do
      assert_equal "Business tax", @subtopic.parent.title
    end

    it "returns the parent base_path" do
      assert_equal "/topic/business-tax", @subtopic.parent.base_path
    end

    it "returns the combined_title" do
      assert_equal "Business tax: PAYE", @subtopic.combined_title
    end

    describe "when parent details are missing" do
      # This should never happen, but it's still good to make this defensive
      setup do
        @api_data["links"].delete("parent")
      end

      it "returns nil for parent" do
        assert_nil @subtopic.parent
      end

      it "returns the subtopic title in combined_title" do
        assert_equal "PAYE", @subtopic.combined_title
      end

      it "handles the links hash missing completely" do
        @api_data.delete("links")
        assert_nil @subtopic.parent
      end
    end
  end

  describe "children" do
    it "returns the title and base_path for all children" do
      @api_data["links"]["children"] = [
        {
          "title"=>"Foo",
          "base_path"=>"/topic/business-tax/foo",
        },
        {
          "title"=>"Bar",
          "base_path"=>"/topic/business-tax/bar",
        },
      ]

      assert_equal 'Foo', @subtopic.children[0].title
      assert_equal '/topic/business-tax/bar', @subtopic.children[1].base_path
    end

    it "returns empty array with no children" do
      assert_equal [], @subtopic.children
    end

    it "returns empty array when the links field is missing" do
      @api_data.delete("links")
      assert_equal [], @subtopic.children
    end
  end

  describe "slug" do
    it "returns the slug for a topic at the root of the namespace" do
      @api_data["base_path"] = "/business-tax/paye"
      assert_equal "business-tax/paye", @subtopic.slug
    end

    it "returns the slug for a topic under the /topic namespace" do
      @api_data["base_path"] = "/topic/business-tax/paye"
      assert_equal "business-tax/paye", @subtopic.slug
    end
  end

  describe "groups" do
    it "should pass the contentapi slug of the topic when constructing groups" do
      Subtopic::Groups.expects(:new).with("business-tax/paye", anything()).returns(:a_groups_instance)

      assert_equal :a_groups_instance, @subtopic.groups
    end

    it "should pass the groups data when constructing" do
      Subtopic::Groups.expects(:new).with(anything(), :some_data).returns(:a_groups_instance)
      @api_data["details"]["groups"] = :some_data

      assert_equal :a_groups_instance, @subtopic.groups
    end
  end

  describe "changed_documents" do
    setup do
      @subtopic = Subtopic.new(@api_data, {:foo => "bar"})
    end

    it "should pass the contentapi slug of the topic when constructing changed_documents" do
      Subtopic::ChangedDocuments.expects(:new).with("business-tax/paye", anything()).returns(:an_instance)
      assert_equal :an_instance, @subtopic.changed_documents
    end

    it "should pass the pagination options when constructing changed_documents" do
      Subtopic::ChangedDocuments.expects(:new).with(anything(), :foo => "bar").returns(:an_instance)
      assert_equal :an_instance, @subtopic.changed_documents
    end
  end
end
