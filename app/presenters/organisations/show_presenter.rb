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
          parent_organisation["base_path"]
        )
      end

      parent_org_links.to_sentence.html_safe
    end

    def has_featured_policies?
      true if @org.ordered_featured_policies && @org.ordered_featured_policies.length.positive?
    end

    def featured_policies
      policies = []

      @org.ordered_featured_policies.each do |policy|
        policies << {
          link: {
            text: policy["title"],
            path: policy["base_path"]
          }
        }
      end

      policies << {
        link: {
          text: "See all our policies",
          path: "/government/policies?organisations[]=#{@org.slug}"
        }
      }

      {
        items: policies,
        brand: @org.brand
      }
    end

    def has_foi_contacts?
      true if @org.foi_contacts && @org.foi_contacts.length.positive?
    end

    def foi_contacts
      @org.foi_contacts.map do |foi_contact|
        {
          title: foi_title(foi_contact["details"]["title"]),
          post_addresses: foi_contact["details"]["post_addresses"].map do |post|
            foi_address(post)
          end,
          email_addresses: foi_contact["details"]["email_addresses"].map do |email|
            make_email_link(email["email"])
          end,
          links: foi_contact["details"]["contact_form_links"].map do |link|
            make_link(link)
          end,
          description: foi_description(foi_contact["details"]["description"])
        }
      end
    end

    def foi_previous_releases_link
      "/government/publications?departments[]=#{@org.slug}&publication_type=foi-releases"
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
          margin_bottom: true
        }
      }
    end

  private

    def contact_line(line)
      return line + "<br/>" if line && line.length.positive?
      ""
    end

    def make_link(link)
      return link_to(make_link_text(link["description"]), link["link"], class: "brand__color") if link["link"].length.positive?
      nil
    end

    def make_link_text(text)
      text.length.positive? ? text : I18n.t('organisations.foi.contact_form')
    end

    def make_email_link(email)
      mail_to(email, email, class: "brand__color")
    end

    def foi_title(title)
      return title if title
      I18n.t('organisations.foi.freedom_of_information_requests')
    end

    def foi_address(post)
      data = ""
      data << contact_line(post["title"])
      data << contact_line(post["street_address"].gsub("\r\n", "<br/>"))
      data << contact_line(post["locality"])
      data << contact_line(post["postal_code"])
      data << contact_line(post["world_location"])
      data = data.gsub("<br/><br/>", "<br/>")
      data if data.length.positive?
    end

    def foi_description(description)
      return content_tag(:p, description.gsub("\r\n", "<br/>").html_safe) if description.length.positive?
    end

    def acronym
      if @org.acronym && !@org.acronym.empty?
        @org.acronym
      else
        prefixed_title
      end
    end

    def needs_definite_article?(phrase)
      exceptions = [/civil service resourcing/, /^hm/, /ordnance survey/]
      !has_definite_article?(phrase) && !(exceptions.any? { |e| e =~ phrase.downcase })
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
