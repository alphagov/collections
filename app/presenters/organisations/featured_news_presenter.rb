module Organisations
  class FeaturedNewsPresenter
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def has_featured_news?
      org.ordered_featured_documents.length.positive?
    end

    def first_featured_news
      main_story = featured_news([org.ordered_featured_documents.first])[0]
      main_story[:large] = true
      main_story
    end

    def remaining_featured_news
      return featured_news(org.ordered_featured_documents.drop(1)) if org.is_news_organisation?
      featured_news(org.ordered_featured_documents)
    end

  private

    def featured_news(featured)
      news_stories = []
      featured.each do |news|
        human_date = Date.parse(news["public_updated_at"]).strftime("%-d %B %Y") if news["public_updated_at"]
        document_type = news["document_type"]
        divider = " — " if human_date && document_type

        news_stories << {
          href: news["href"],
          image_src: news["image"]["url"],
          image_alt: news["image"]["alt"],
          context: "#{human_date}#{divider}#{document_type}",
          heading_text: news["title"],
          description: news["summary"],
          brand: org.brand
        }
      end

      news_stories
    end
  end
end
