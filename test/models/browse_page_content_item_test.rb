require "test_helper"

describe BrowsePageContentItem do
  describe '#lists' do
    it "returns an A-Z list when there is no curation" do
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]

      lists = BrowsePageContentItem.new('crime-and-justice/judges', stub(:details)).lists

      assert_equal 1, lists.size
      assert_equal 'A to Z', lists.first.name
      assert_equal 'Judge dredd', lists.first.links.first.title
    end

    it "returns a curated list when there is curation" do
      content_item = { details: { groups: [ { name: "Movie Judges", contents: [
        'https://contentapi.test.gov.uk/doesnt-exist-anymore.json',
        'https://contentapi.test.gov.uk/judge-dredd.json' ] }]}
      }
      content_store_has_item '/browse/crime-and-justice/judges', content_item
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]
      content_store_item = ContentItem.find!('/browse/crime-and-justice/judges')

      lists = BrowsePageContentItem.new('crime-and-justice/judges', content_store_item).lists

      assert_equal 1, lists.size
      assert_equal 'Movie Judges', lists.first.name
      assert_equal 'Judge dredd', lists.first.links.first.title
    end
  end

  describe '#curated_links?' do
    it "returns false when there is no curation" do
      content_item = stub(:details)

      sub_section = BrowsePageContentItem.new('crime-and-justice/judges', content_item)

      refute sub_section.curated_links?
    end

    it "returns false when there is an empty list of gurated groups" do
      content_store_has_item '/browse/crime-and-justice/judges', { details: { groups: [] } }
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]

      sub_section = BrowsePageContentItem.new('crime-and-justice/judges', stub(:details))

      refute sub_section.curated_links?
    end

    it "returns true when there are grouped links in the content store" do
      content_store_has_item '/browse/crime-and-justice/judges', { details: { groups: [ { name: "Movie Judges", contents: ['https://contentapi.test.gov.uk/judge-dredd.json'] }]} }
      content_api_has_artefacts_with_a_tag "section", "crime-and-justice/judges", ["judge-dredd"]
      content_store_item = ContentItem.find!('/browse/crime-and-justice/judges')

      sub_section = BrowsePageContentItem.new('crime-and-justice/judges', content_store_item)

      assert sub_section.curated_links?
    end
  end
end
