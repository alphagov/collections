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
            data = ""
            data << contact_line(post["title"])
            data << contact_line(post["street_address"].gsub("\r\n", "<br/>"))
            data << contact_line(post["locality"])
            data << contact_line(post["postal_code"])
            data << contact_line(post["world_location"])
          end,
          email_addresses: foi_contact["details"]["email_addresses"].map do |email|
            make_email_link(email["email"])
          end,
          description: foi_description(foi_contact["details"]["description"])
        }
      end
    end

    def foi_previous_releases_link
      "/government/publications?departments[]=#{@org.slug}&publication_type=foi-releases"
    end

  private

    def contact_line(line)
      return line + "<br/>" if line && line.length.positive?
      ""
    end

    def make_email_link(email)
      mail_to(email, email, class: "brand__color")
    end

    def foi_title(title)
      return title if title
      I18n.t('organisations.foi.freedom_of_information_requests')
    end

    def foi_description(contact)
      content_tag(:p, contact.gsub("\r\n", "<br/>").html_safe) if contact
    end

    def needs_definite_article?(phrase)
      exceptions = [/civil service resourcing/, /^hm/, /ordnance survey/]
      !has_definite_article?(phrase) && !(exceptions.any? { |e| e =~ phrase.downcase })
    end

    def has_definite_article?(phrase)
      phrase.downcase.strip[0..2] == 'the'
    end
  end
end
