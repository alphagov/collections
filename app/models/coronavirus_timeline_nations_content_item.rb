class CoronavirusTimelineNationsContentItem < ContentItem
  def self.load
    json = File.read(
      Rails.root.join("config/data/temporary_test_coronavirus_landing_page_with_timeline_nations.json"),
    )
    response = JSON.parse(json)

    new(response.to_hash)
  end
end
