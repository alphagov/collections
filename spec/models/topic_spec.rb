RSpec.describe Topic do
  let(:api_data) do
    {
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
  end

  let(:content_item) { ContentItem.new(api_data) }
  subject { described_class.new(content_item) }

  describe "basic properties" do
    it "returns the topic base_path" do
      expect(subject.base_path).to eq("/topic/business-tax/paye")
    end

    it "returns the topic title" do
      expect(subject.title).to eq("PAYE")
    end

    it "returns the topic content ID" do
      expect(subject.content_id).to eq("uuid-23")
    end

    it "returns the topic description" do
      expect(subject.description).to eq("Pay As You Earn")
    end
  end

  describe "parent" do
    it "returns the parent title" do
      expect(subject.parent.title).to eq("Business tax")
    end

    it "returns the parent base_path" do
      expect(subject.parent.base_path).to eq("/topic/business-tax")
    end

    it "returns the combined_title" do
      expect(subject.combined_title).to eq("Business tax: PAYE - detailed information")
    end

    context "when parent details are missing" do
      # This should never happen, but it's still good to make this defensive
      before do
        api_data["links"].delete("parent")
      end

      it "returns nil for parent" do
        expect(subject.parent).to be_nil
      end

      it "returns the topic title in combined_title" do
        expect(subject.combined_title).to eq("PAYE: detailed information")
      end

      it "handles the links hash missing completely" do
        api_data.delete("links")
        expect(subject.parent).to be_nil
      end
    end
  end

  describe "children" do
    it "returns the title and base_path for all children" do
      api_data["links"]["children"] = [
        {
          "title" => "Foo",
          "base_path" => "/topic/business-tax/foo",
        },
        {
          "title" => "Bar",
          "base_path" => "/topic/business-tax/bar",
        },
      ]

      expect(subject.children[0].title).to eq("Bar")
      expect(subject.children[1].title).to eq("Foo")
    end

    it "returns empty array with no children" do
      expect(subject.children).to eq([])
    end

    it "returns empty array when the links field is missing" do
      api_data.delete("links")
      expect(subject.children).to eq([])
    end
  end

  describe "slug" do
    it "returns the slug for a subtopic" do
      api_data["base_path"] = "/topic/business-tax/paye"
      expect(subject.slug).to eq("business-tax/paye")
    end

    it "returns the slug for a top-level topic" do
      api_data["base_path"] = "/topic/business-tax"
      expect(subject.slug).to eq("business-tax")
    end
  end

  describe "lists" do
    it "passes the slug of the topic when constructing groups" do
      expect(ListSet)
      .to receive(:new)
      .with("specialist_sector", content_item.content_id, nil)
      .and_call_original

      expect(subject.lists).to be_an_instance_of(ListSet)
    end

    it "passes the groups data when constructing" do
      expect(ListSet)
      .to receive(:new)
      .with("specialist_sector", content_item.content_id, :some_data)
      .and_call_original

      api_data["details"]["groups"] = :some_data
      expect(subject.lists).to be_an_instance_of(ListSet)
    end
  end

  describe "changed_documents" do
    it "passes the content id of the topic when constructing changed_documents" do
      expect(Topic::ChangedDocuments)
      .to receive(:new)
      .with(content_item.content_id, {})
      .and_return(:an_instance)

      expect(subject.changed_documents).to eq(:an_instance)
    end

    it "passes the pagination options when constructing changed_documents" do
      subject = described_class.new(content_item, foo: "bar")

      expect(Topic::ChangedDocuments)
      .to receive(:new)
      .with(content_item.content_id, foo: "bar")
      .and_return(:an_instance)

      expect(subject.changed_documents).to eq(:an_instance)
    end
  end
end
