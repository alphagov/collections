class SpecialAnnouncementPresenter
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def payload
    @payload ||= creative_work.merge(special_announcement_properties)
  end

private

  def special_announcement_properties
    schema_specific_links = content_item.dig("details", "special_announcement_schema") || {}

    {
      "@type" => "SpecialAnnouncement",
      "category" => schema_specific_links["category"],
      "datePosted" => content_item["public_updated_at"],
      "diseasePreventionInfo" => schema_specific_links["disease_prevention_info_url"],
      "diseaseSpreadStatistics" => schema_specific_links["disease_spread_statistics_url"],
      "gettingTestedInfo" => schema_specific_links["getting_tested_info_url"],
      "newsUpdatesAndGuidelines" => schema_specific_links["news_updates_and_guidelines_url"],
      "publicTransportClosuresInfo" => schema_specific_links["public_transport_closures_info_url"],
      "quarantineGuidelines" => schema_specific_links["quarantine_guidelines_url"],
      "schoolClosuresInfo" => schema_specific_links["school_closures_info_url"],
      "travelBans" => schema_specific_links["travel_bans_url"],
    }.compact
  end

  def creative_work
    page = GovukPublishingComponents::Presenters::Page.new({ content_item: content_item })
    GovukPublishingComponents::Presenters::CreativeWorkSchema.new(page).structured_data
  end
end
