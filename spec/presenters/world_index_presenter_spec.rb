RSpec.describe WorldIndexPresenter do
  let(:fixture) { GovukSchemas::Example.find("world_index", example_name: "world_index") }
  let(:content_item) { ContentItem.new(fixture) }
  let(:world_index) { WorldIndex.new(content_item) }
  let(:world_index_presenter) { described_class.new(world_index) }

  describe "#title" do
    subject { world_index_presenter.title }

    it "returns the title from the content item" do
      expect(subject).to eq("Help and services around the world")
    end
  end

  describe "#grouped_world_locations" do
    subject { world_index_presenter.grouped_world_locations }

    it "groups world locations by letter" do
      expect(subject.length).to be 25 # No locations beginning with `X`
      expect(subject.first.first).to eq "A"
      expect(subject.last.first).to eq "Z"
    end

    it "disregards the `The` prefix of world location names when grouping" do
      g_group = subject.find { |group| group.first == "G" }
      g_group_locations = g_group.last

      expect(g_group_locations.pluck("name")).to include "The Gambia"
    end
  end

  describe "#world_locations_count" do
    subject { world_index_presenter.world_locations_count }

    it "returns the number of world locations" do
      expect(subject).to be 229
    end
  end

  describe "#world_location_link" do
    subject { world_index_presenter.world_location_link(location) }

    context "when the location is active" do
      let(:location) do
        {
          "active": true,
          "name": "Afghanistan",
          "slug": "afghanistan",
        }.with_indifferent_access
      end

      it "returns a link to the location" do
        expect(subject).to eq "<a class=\"govuk-link\" href=\"/world/afghanistan\">Afghanistan</a>"
      end
    end

    context "when the location is inactive" do
      let(:location) do
        {
          "active": false,
          "name": "United Kingdom",
          "slug": "united-kingdom",
        }.with_indifferent_access
      end

      it "returns the location" do
        expect(subject).to eq "<span>United Kingdom</span>"
      end
    end
  end

  describe "#filter_terms" do
    let(:location) do
      {
        "name": "United Kingdom",
        "slug": "united-kingdom",
      }.with_indifferent_access
    end

    subject { world_index_presenter.filter_terms(location) }

    it "returns the joined name and slug" do
      expect(subject).to eq "united-kingdom United Kingdom"
    end
  end

  describe "#international_delegations_count" do
    subject { world_index_presenter.international_delegations_count }

    it "returns the number of international delegations" do
      expect(subject).to be 10
    end
  end
end
