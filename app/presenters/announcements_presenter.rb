class AnnouncementsPresenter
  attr_reader :slug

  def initialize(slug)
    @slug = slug
  end

  def items
    announcements.map do |announcenment|
      {
        link: {
          text: announcenment["title"],
          path: announcenment["link"],
        },
        metadata: {
          public_timestamp: Date.parse(announcenment["public_timestamp"]).strftime("%d %B %Y"),
          content_store_document_type: announcenment["content_store_document_type"].humanize,
        },
      }
    end
  end

  def links
    {
      email_signup: "/email-signup?link=/government/people/#{slug}",
      subscribe_to_feed: "https://www.gov.uk/government/people/#{slug}.atom",
      link_to_news_and_communications: "/search/news-and-communications?people=#{slug}",
    }
  end

private

  def announcements
    @announcements ||= Services.cached_search(
      count: 10,
      order: "-public_timestamp",
      filter_people: slug_without_locale,
      reject_content_purpose_supergroup: "other",
      fields: %w[title link content_store_document_type public_timestamp],
    )["results"]
  end

  def slug_without_locale
    slug.split(".").first
  end
end
