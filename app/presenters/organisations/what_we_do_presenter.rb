module Organisations
  class WhatWeDoPresenter
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def has_share_links?(req)
      return unless req && org.social_media_links.present?

      request_locale = req.filtered_parameters["locale"] || "en"
      org.social_media_links.select { |k, _| k["locale"] == request_locale }
    end

    def share_links(req)
      social = has_share_links?(req)
      links = []

      social.each do |link|
        link_has_cta = ["Sign up", "Follow", "Watch", "Read"].any? { |cta| link["title"].include?(cta) }
        links << {
          href: link["href"],
          text: link["title"],
          hidden_text: link_has_cta ? "" : "Follow on",
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
