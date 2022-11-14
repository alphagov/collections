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
        link_has_cta = ["Sign up", "Follow", "Watch", "Read"].any? { |cta| link["title"].include?(cta) }
        links << {
          href: link["href"],
          text: link["title"],
          hidden_text: link_has_cta ? "" : I18n.t("organisations.hidden_share_link"),
          icon: link["service_type"],
        }
      end

      {
        stacked: true,
        track_as_follow: true,
        brand: org.brand,
        links:,
      }
    end
  end
end
