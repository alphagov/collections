require "test_helper"

describe Subtopic do
  setup do
    @api_data = {
      "base_path" => "/business-tax/paye",
      "title" => "PAYE",
      "description" => "Pay As You Earn",
      "details" => {
      },
      "links" => {
        "parent" => [{
          "title"=>"Business tax",
          "base_path"=>"/business-tax",
          "description"=>"All about tax for businesses",
        }],
      },
    }
    @subtopic = Subtopic.new(@api_data)
  end

  describe "basic properties" do
    it "returns the subtopic base_path" do
      assert_equal "/business-tax/paye", @subtopic.base_path
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
      assert_equal "/business-tax", @subtopic.parent.base_path
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
    end
  end
end
