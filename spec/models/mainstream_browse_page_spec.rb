RSpec.describe MainstreamBrowsePage do
  let(:api_data) do
    {
      "content_id" => "f818b54c-01c7-43e9-8165-cec12e4053ff",
      "base_path" => "/browse/benefits/child",
      "title" => "Child Benefit",
      "description" => "Information about eligibility, claiming and when Child Benefit stops",
      "details" => {},
      "links" => {},
    }
  end
  let(:content_item) { ContentItem.new(api_data) }
  let(:page) { described_class.new(content_item) }

  describe "basic properties" do
    it "returns the browse page content_id" do
      expect(page.content_id).to eq("f818b54c-01c7-43e9-8165-cec12e4053ff")
    end

    it "returns the browse page base_path" do
      expect(page.base_path).to eq("/browse/benefits/child")
    end

    it "returns the browse page title" do
      expect(page.title).to eq("Child Benefit")
    end

    it "returns the browse page description" do
      expect(page.description).to eq("Information about eligibility, claiming and when Child Benefit stops")
    end

    describe "#second_level_pages_curated?" do
      it "is true when second_level_ordering == curated" do
        api_data["details"]["second_level_ordering"] = "curated"
        expect(page.second_level_pages_curated?).to be(true)
      end

      it "is false when second_level_ordering == alphabetical" do
        api_data["details"]["second_level_ordering"] = "alphabetical"
        expect(page.second_level_pages_curated?).to be(false)
      end

      it "is false when second_level_ordering is unspecified" do
        api_data["details"] = {}
        expect(page.second_level_pages_curated?).to be(false)
      end

      it "is false when details hash is missing" do
        api_data.delete("details")
        expect(page.second_level_pages_curated?).to be(false)
      end
    end

    describe "#second_level_browse_pages" do
      let(:second_level_browse_page1) do
        {
          "content_id" => "1",
          "title" => "Foo",
          "description" => "All about foo",
          "base_path" => "/browse/foo",
        }
      end
      let(:second_level_browse_page2) do
        {
          "content_id" => "2",
          "title" => "Bar",
          "description" => "All about bar",
          "base_path" => "/browse/bar",
        }
      end

      before do
        api_data["details"]["ordered_second_level_browse_pages"] = %w[1 2]
        api_data["links"]["second_level_browse_pages"] = [
          second_level_browse_page2,
          second_level_browse_page1,
        ]
      end

      it "returns a curated set of links when second_level_ordering == curated" do
        api_data["details"]["second_level_ordering"] = "curated"
        expected = [
          second_level_browse_page1["content_id"],
          second_level_browse_page2["content_id"],
        ]
        expect(page.second_level_browse_pages.map(&:content_id)).to eq(expected)
      end

      it "returns an alphabetically ordered set of links when second_level_ordering == alphabetical" do
        api_data["details"]["second_level_ordering"] = "alphabetical"
        expected = [
          second_level_browse_page2["content_id"],
          second_level_browse_page1["content_id"],
        ]
        expect(page.second_level_browse_pages.map(&:content_id)).to eq(expected)
      end
    end
  end

  %w[top_level_browse_pages second_level_browse_pages].each do |link_type|
    describe link_type do
      it "returns the title, base_path and description for all linked items" do
        api_data["links"][link_type] = [
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

        items = page.public_send(link_type)

        expect(items[0].title).to eq("Bar")
        expect(items[0].description).to eq("All about bar")
        expect(items[0].base_path).to eq("/browse/bar")

        expect(items[1].title).to eq("Foo")
        expect(items[1].description).to eq("All about foo")
        expect(items[1].base_path).to eq("/browse/foo")
      end

      it "returns empty array with no items" do
        expect(page.public_send(link_type)).to eq([])
      end

      it "returns empty array when the links field is missing" do
        api_data.delete("links")
        expect(page.public_send(link_type)).to eq([])
      end
    end
  end

  it "filters items without title" do
    api_data["links"]["second_level_browse_pages"] = [
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

    items = page.second_level_browse_pages

    expect(items[0].title).to eq("Bar")
    expect(items[0].description).to eq("All about bar")
    expect(items[0].base_path).to eq("/browse/bar")
  end

  describe "active_top_level_browse_page" do
    it "returns the title, base_path and description for the linked item" do
      api_data["links"]["active_top_level_browse_page"] = [{
        "title" => "Foo",
        "description" => "All about foo",
        "base_path" => "/browse/foo",
      }]

      expect(page.active_top_level_browse_page.title).to eq("Foo")
      expect(page.active_top_level_browse_page.base_path).to eq("/browse/foo")
      expect(page.active_top_level_browse_page.description).to eq("All about foo")
    end

    it "returns nil with no items" do
      expect(page.active_top_level_browse_page).to be_nil
    end

    it "returns nil when the links field is missing" do
      api_data.delete("links")
      expect(page.active_top_level_browse_page).to be_nil
    end
  end

  describe "related_topics" do
    it "returns the title, base_path and description for all related topics" do
      api_data["links"]["related_topics"] = [
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

      expect(page.related_topics[1].title).to eq("Foo")
      expect(page.related_topics[0].base_path).to eq("/browse/bar")
      expect(page.related_topics[1].description).to eq("All about foo")
    end

    it "returns related topics alphabetised" do
      api_data["links"]["related_topics"] = [
        {
          "title" => "Foo",
        },
        {
          "title" => "Bar",
        },
      ]

      expect(page.related_topics.map(&:title)).to eq(%w[Bar Foo])
    end

    it "returns empty array with no items" do
      expect(page.related_topics).to eq([])
    end

    it "returns empty array when the links field is missing" do
      api_data.delete("links")
      expect(page.related_topics).to eq([])
    end
  end

  describe "slug" do
    it "returns the slug for a top-level browse page" do
      api_data["base_path"] = "/browse/benefits"
      expect(page.slug).to eq("benefits")
    end

    it "returns the slug for a child browse page" do
      api_data["base_path"] = "/browse/benefits/child"
      expect(page.slug).to eq("benefits/child")
    end
  end

  describe "lists" do
    it "should pass the groups data and content id of the browse page when constructing list sets" do
      api_data["details"]["groups"] = :some_data
      expect(ListSet)
        .to receive(:new)
        .with("section", content_item.content_id, :some_data)
        .and_call_original
      expect(page.lists).to be_an_instance_of(ListSet)
    end

    it "should pass in nil if the data is missing" do
      api_data.delete("details")
      expect(ListSet)
        .to receive(:new)
        .with("section", content_item.content_id, nil)
        .and_call_original
      expect(page.lists).to be_an_instance_of(ListSet)
    end
  end
end
