module Organisations
  class ShowPresenter
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper

    def initialize(organisation)
      @org = organisation
    end

    def prefixed_title
      prefix = needs_definite_article?(@org.title) ? "the " : ""
      (prefix + @org.title)
    end

    def subscription_links
      {
        email_signup_link: "/government/email-signup/new?email_signup[feed]=#{@org.web_url}.atom",
        feed_link_box_value: "#{@org.web_url}.atom",
        brand: @org.brand
      }
    end

    def parent_organisations
      parent_org_links = @org.ordered_parent_organisations.map do |parent_organisation|
        link_to(
          parent_organisation["title"],
          parent_organisation["base_path"],
          class: "brand__color"
        )
      end

      parent_org_links.to_sentence.html_safe
    end

    def high_profile_groups
      high_profile_groups = @org.ordered_high_profile_groups && @org.ordered_high_profile_groups.map do |group|
        {
          text: group["title"],
          path: group["base_path"]
        }
      end

      {
        title: I18n.t('organisations.high_profile_groups', title: acronym),
        brand: @org.brand,
        items: high_profile_groups
      }
    end

    def corporate_information
      corporate_information_links = @org.ordered_corporate_information.map do |link|
        {
          text: link["title"],
          path: link["href"],
        }
      end

      job_links = separate_job_links(corporate_information_links)

      {
        corporate_information_links: {
          items: corporate_information_links - job_links,
          brand: @org.brand,
          margin_bottom: true
        },
        job_links: {
          items: job_links,
          brand: @org.brand,
          margin_bottom: @org.secondary_corporate_information.present?
        }
      }
    end

    def acronym
      if @org.acronym && !@org.acronym.empty?
        @org.acronym
      else
        prefixed_title
      end
    end

  private

    NEED_A_THE = %w(
      authority
      agency
      bank
      board
      body
      centre
      college
      commission
      committee
      council
      department
      fund
      group
      hospital
      inquiry
      inspectorate
      ministry
      office
      panel
      review
      service
      team
      tribunal
    ).freeze

    NO_THE = "civil service resourcing|civil service reform".freeze

    def needs_definite_article?(phrase)
      should_have = Regexp::new(NEED_A_THE.join("|"), true)
      should_not_have = Regexp::new(NO_THE, true)

      !has_definite_article?(phrase) &&
        (@org.is_court_or_hmcts_tribunal? ||
        (should_have =~ phrase) && (should_not_have !~ phrase))
    end

    def has_definite_article?(phrase)
      phrase.downcase.strip[0..2] == 'the'
    end

    def separate_job_links(corporate_information_links)
      job_links = []

      corporate_information_links.each do |link|
        if link[:path].end_with?("/recruitment", "/procurement") || link[:text].eql?("Jobs")
          job_links << link
        end
      end

      job_links
    end
  end
end
