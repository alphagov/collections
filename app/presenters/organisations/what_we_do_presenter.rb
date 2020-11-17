module Organisations
  class WhatWeDoPresenter
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def has_share_links?
      org.social_media_links.present?
    end

    def share_links
      links = []

      org.social_media_links.each do |link|
        links << {
          href: link["href"],
          text: link["title"],
          hidden_text: link["title"].include?('Sign up') ? "" : "Follow on",
          icon: link["service_type"],
        }
      end

      {
        stacked: true,
        brand: org.brand,
        links: links,
      }
    end
  end
end
