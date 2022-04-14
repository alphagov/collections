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
    {
      "@type" => "SpecialAnnouncement",
      "category" => "https://www.wikidata.org/wiki/Q81068910",
      "datePosted" => content_item["public_updated_at"],
      "diseasePreventionInfo" => "https://www.nhs.uk/conditions/coronavirus-covid-19/",
      "diseaseSpreadStatistics" => "https://www.gov.uk/government/publications/covid-19-track-coronavirus-cases",
      "gettingTestedInfo" => "https://www.gov.uk/apply-coronavirus-test",
      "newsUpdatesAndGuidelines" => "https://www.gov.uk/coronavirus",
      "publicTransportClosuresInfo" => "https://www.gov.uk/guidance/coronavirus-covid-19-uk-transport-and-travel-advice",
      "quarantineGuidelines" => "https://www.gov.uk/government/publications/coronavirus-outbreak-faqs-what-you-can-and-cant-do/coronavirus-outbreak-faqs-what-you-can-and-cant-do",
      "schoolClosuresInfo" => "https://www.gov.uk/check-school-closure",
      "travelBans" => "https://www.gov.uk/guidance/travel-advice-novel-coronavirus",
    }.compact
  end

  def creative_work
    page = GovukPublishingComponents::Presenters::Page.new({ content_item: content_item })
    GovukPublishingComponents::Presenters::CreativeWorkSchema.new(page).structured_data
  end
end
