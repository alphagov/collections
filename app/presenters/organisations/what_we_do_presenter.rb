module Organisations
  class WhatWeDoPresenter
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def share_links
      links = []

      org.social_media_links.each do |link|
        links << {
          href: link["href"],
          text: link["title"],
          icon: link["service_type"]
        }
      end

      {
        stacked: true,
        brand: org.brand,
        links: links
      }
    end

    def what_we_do_title
      prefix = needs_definite_article?(org.title) ? "the " : ""
      (prefix + org.title)
    end

  private

    def needs_definite_article?(phrase)
      exceptions = [/civil service resourcing/, /^hm/, /ordnance survey/]
      !has_definite_article?(phrase) && !(exceptions.any? { |e| e =~ phrase.downcase })
    end

    def has_definite_article?(phrase)
      phrase.downcase.strip[0..2] == 'the'
    end
  end
end
