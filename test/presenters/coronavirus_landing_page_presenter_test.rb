require "test_helper"
require_relative "../../test/support/coronavirus_helper"

describe CoronavirusLandingPagePresenter do
  it "provides getter methods for all component keys" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    %i[live_stream stay_at_home guidance announcements_label announcements nhs_banner sections topic_section country_section notifications].each do |method|
      assert_respond_to(presenter, method)
    end
  end

  it "build valid FAQ Schema" do
    stub_content_store_has_item(CORONAVIRUS_TAXON_PATH, coronavirus_root_taxon_content_item)
    presenter = described_class.new(coronavirus_landing_page_content_item)
    faq_schema = presenter.faq_schema(coronavirus_landing_page_content_item)
    assert_equal(faq_schema[:@context], "https://schema.org")
    assert_equal(faq_schema[:@type], "FAQPage")

    faq_schema[:mainEntity].each do |question|
      assert_equal(question[:@type], "Question")
      assert_equal(question[:acceptedAnswer][:@type], "Answer")
    end
  end

  it "has sub_sections for sections with child taxons" do
    stub_content_store_has_item(CORONAVIRUS_TAXON_PATH, coronavirus_root_taxon_content_item)
    presenter = described_class.new(coronavirus_landing_page_content_item)
    assert_equal 2, presenter.sections.count

    first_section = presenter.sections.first
    assert_equal 1, first_section["sub_sections"].count
    assert_nil first_section["sub_sections"].first["title"]

    second_section = presenter.sections.second
    assert_equal 2, second_section["sub_sections"].count
    assert_equal "Associates", second_section["sub_sections"].first["title"]
    assert_equal "A level", second_section["sub_sections"].second["title"]
  end

  it "can override taxon names for sub sections" do
    stub_content_store_has_item(CORONAVIRUS_TAXON_PATH, coronavirus_root_taxon_content_item)
    TaxonomySectionsPresenter.any_instance
        .stubs(:title_overrides)
        .returns({ coronavirus_taxon_two_child_one["content_id"] => "new title" })
    presenter = described_class.new(coronavirus_landing_page_content_item)
    assert_equal 2, presenter.sections.count

    second_section = presenter.sections.second
    assert_equal 2, second_section["sub_sections"].count
    assert_equal "new title", second_section["sub_sections"].first["title"]
    assert_equal "A level", second_section["sub_sections"].second["title"]
  end

  it "can display sections as hub pages" do
    stub_content_store_has_item(CORONAVIRUS_TAXON_PATH, coronavirus_root_taxon_content_item)
    TaxonomySectionsPresenter.any_instance
        .stubs(:hub_urls)
        .returns([coronavirus_taxon_two_with_children["content_id"]])
    presenter = described_class.new(coronavirus_landing_page_content_item)

    assert_nil presenter.sections.first["hub_url"]
    assert_equal coronavirus_taxon_two_with_children["base_path"], presenter.sections.second["hub_url"]
  end
end
