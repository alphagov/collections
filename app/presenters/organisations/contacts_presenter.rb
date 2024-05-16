module Organisations
  class ContactsPresenter
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper

    def initialize(organisation)
      @org = organisation
    end

    def has_contacts?
      @org.ordered_contacts.present?
    end

    def contacts
      format_contacts(@org.ordered_contacts)
    end

    def has_foi_contacts?
      @org.foi_contacts.present?
    end

    def foi_contacts
      format_contacts(@org.foi_contacts, foi: true)
    end

    def foi_previous_releases_link
      "/government/publications?departments[]=#{@org.slug}&publication_type=foi-releases"
    end

  private

    def format_contacts(contacts, foi: false)
      contacts.map do |contact|
        {
          locale: contact["locale"].presence,
          title: foi_title(contact["details"]["title"], foi:),
          post_addresses: contact["details"]["post_addresses"]&.map do |post|
            contact_address(post)
          end || [],
          phone_numbers: contact["details"]["phone_numbers"]&.map do |phone|
            {
              title: phone["title"] || I18n.t("organisations.contact.telephone"),
              number: phone["number"],
            }
          end || [],
          email_addresses: contact["details"]["email_addresses"]&.map do |email|
            make_email_link(email["email"])
          end || [],
          links: contact["details"]["contact_form_links"]&.map do |link|
            make_link(link, foi_title(contact["details"]["title"], foi:), foi)
          end || [],
          description: contact_description(contact["details"]["description"]),
        }
      end
    end

    def contact_line(line)
      return "#{line}<br/>" if line.present?

      ""
    end

    def make_link(link, contact_title, foi)
      if link["link"].present?
        link_to(
          make_link_text(link["description"], contact_title, foi:),
          link["link"],
          class: "govuk-link brand__color",
        )
      end
    end

    def make_link_text(text, contact_title, foi: false)
      if text.present?
        text
      elsif foi
        I18n.t("organisations.foi.contact_form")
      else
        I18n.t("organisations.contact.contact_form", title: contact_title)
      end
    end

    def make_email_link(email)
      mail_to(email, email, class: "govuk-link brand__color") unless email.empty?
    end

    def foi_title(title, foi: false)
      if title
        title
      elsif foi
        I18n.t("organisations.foi.freedom_of_information_requests")
      else
        I18n.t("organisations.contact.contact_details")
      end
    end

    def contact_address(post)
      compacted_addresses = post.delete_if { |_key, address_line| address_line.blank? }

      if compacted_addresses
        data = ""
        data << contact_line(post["title"])
        data << contact_line(post["street_address"]&.gsub("\r\n", "<br/>"))
        data << contact_line(post["locality"])
        data << contact_line(post["region"])
        data << contact_line(post["postal_code"])
        data << contact_line(post["world_location"])
        data = data.gsub("<br/><br/>", "<br/>")
      end

      data.presence
    end

    def contact_description(description)
      tag.p(description.gsub("\r\n", "<br/>").html_safe, class: "organisation__paragraph") if description.present?
    end
  end
end
