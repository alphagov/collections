class AnnouncementsPresenter
  attr_reader :slug, :slug_prefix, :filter_key

  def initialize(slug, filter_key:, slug_prefix: nil)
    @slug = slug
    @slug_prefix = slug_prefix || filter_key
    @filter_key = filter_key
  end

  def items
    announcements.map do |announcement|
      {
        link: {
          text: announcement["title"],
          path: announcement["link"],
        },
        metadata: {
          public_timestamp: Date.parse(announcement["public_timestamp"]).strftime("%d %B %Y"),
          content_store_document_type: announcement["content_store_document_type"].humanize,
        },
      }
    end
  end

  def links
    {
      email_signup: "/email-signup?link=/government/#{slug_prefix}/#{slug_without_locale}",
      subscribe_to_feed: "/search/news-and-communications.atom?#{filter_key}=#{slug_without_locale}",
      link_to_news_and_communications: "/search/news-and-communications?#{filter_key}=#{slug_without_locale}",
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
