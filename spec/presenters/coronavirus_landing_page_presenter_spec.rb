require "test_helper"
require_relative "../../test/support/coronavirus_helper"

describe CoronavirusLandingPagePresenter do
  it "provides getter methods for all component keys" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    %i[
      live_stream
      live_stream_enabled
      header_section
      announcements_label
      announcements
      see_all_announcements_link
      risk_level
      nhs_banner
      sections
      sections_heading
      additional_country_guidance
      topic_section
      statistics_section
      notifications
      find_help
      page_header
      timeline
    ].each do |method|
      assert_respond_to(presenter, method)
    end
  end

  it "build valid FAQ Schema" do
    presenter = described_class.new(coronavirus_landing_page_content_item)
    faq_schema = presenter.faq_schema(coronavirus_landing_page_content_item)
    assert_equal(faq_schema[:@context], "https://schema.org")
    assert_equal(faq_schema[:@type], "FAQPage")

    faq_schema[:mainEntity].each do |question|
      assert_equal(question[:@type], "Question")
      assert_equal(question[:acceptedAnswer][:@type], "Answer")
    end
  end
end
