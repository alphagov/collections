require "test_helper"

describe SubSection do
  describe '#lists' do
    before do
      content_api_has_section "crime-and-justice"
      content_api_has_subsections "crime-and-justice", ["judges"]
    end

    it "returns an A-Z list when there is no curation" do
      content_store_has_item '/browse/crime-and-justice/judges', { details: { } }
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]

      lists = SubSection.new('crime-and-justice/judges').lists

      assert_equal 1, lists.size
      assert_equal 'A&#8202;to&#8202;Z', lists.first.name
      assert_equal 'Judge dredd', lists.first.links.first.title
    end

    it "returns a curated list when there is curation" do
      content_item = { details: { groups: [ { name: "Movie Judges", contents: [
        'https://contentapi.test.gov.uk/doesnt-exist-anymore.json',
        'https://contentapi.test.gov.uk/judge-dredd.json' ] }]}
      }
      content_store_has_item '/browse/crime-and-justice/judges', content_item
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]

      lists = SubSection.new('crime-and-justice/judges').lists

      assert_equal 1, lists.size
      assert_equal 'Movie Judges', lists.first.name
      assert_equal 'Judge dredd', lists.first.links.first.title
    end
  end

  describe '#curated_links?' do
    it "returns false when there is no curation" do
      content_store_has_item '/browse/crime-and-justice/judges', { details: { } }
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]

      sub_section = SubSection.new('crime-and-justice/judges')

      refute sub_section.curated_links?
    end

    it "returns false when there is an empty list of gurated groups" do
      content_store_has_item '/browse/crime-and-justice/judges', { details: { groups: [] } }
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]

      sub_section = SubSection.new('crime-and-justice/judges')

      refute sub_section.curated_links?
    end

    it "returns true when there are grouped links in the content store" do
      content_store_has_item '/browse/crime-and-justice/judges', { details: { groups: [ { name: "Movie Judges", contents: ['https://contentapi.test.gov.uk/judge-dredd.json'] }]} }
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]

      sub_section = SubSection.new('crime-and-justice/judges')

      assert sub_section.curated_links?
    end
  end

  describe '#exists?' do
    it "returns true if there is a artefact" do
      content_api_has_tag("section", "crime-and-justice/judges")

      sub_section = SubSection.new('crime-and-justice/judges')

      assert sub_section.exists?
    end

    it "returns false if there is no artefact" do
      api_returns_404_for("/tags/crime-and-justice%2Fno-such-section.json")

      sub_section = SubSection.new('crime-and-justice/no-such-section')

      refute sub_section.exists?
    end
  end
end
