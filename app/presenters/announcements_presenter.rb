class AnnouncementsPresenter
  attr_reader :slug, :slug_prefix, :filter_key

  def initialize(slug, slug_prefix: nil, filter_key:)
    @slug = slug
    @slug_prefix = slug_prefix || filter_key
    @filter_key = filter_key
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
      email_signup: "/email-signup?link=/government/#{slug_prefix}/#{slug}",
      subscribe_to_feed: "https://www.gov.uk/government/#{slug_prefix}/#{slug}.atom",
      link_to_news_and_communications: "/search/news-and-communications?#{filter_key}=#{slug}",
    }
  end

private

  def announcements
    @announcements ||= Services.cached_search(search_options)["results"]
  end

  def search_options
    {
      count: 10,
      order: "-public_timestamp",
      reject_content_purpose_supergroup: "other",
      fields: %w[title link content_store_document_type public_timestamp],
    }.tap do |hash|
      hash[:"filter_#{filter_key}"] = slug_without_locale
    end
  end

  def slug_without_locale
    slug.split(".").first
  end
end
