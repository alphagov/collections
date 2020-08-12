require "test_helper"

describe Organisations::ContactsPresenter do
  include RummagerHelpers
  include OrganisationHelpers

  describe "FOI" do
    before :each do
      content_item = ContentItem.new(organisation_with_foi)
      organisation = Organisation.new(content_item)
      @contacts_presenter = Organisations::ContactsPresenter.new(organisation)
    end

    it "formats foi contacts correctly" do
      expected = [
        {
          locale: "en",
          title: "FOI stuff",
          post_addresses: [
            "Office of the Secretary of State for Wales<br/>Gwydyr House<br/>Whitehall<br/>SW1A 2NP<br/>UK<br/>",
            "Office of the Secretary of State for Wales Cardiff<br/>White House<br/>Cardiff<br/>W1 3BZ<br/>",
          ],
          phone_numbers: [],
          email_addresses: [
            "<a class=\"govuk-link brand__color\" href=\"mailto:walesofficefoi@walesoffice.gsi.gov.uk\">walesofficefoi@walesoffice.gsi.gov.uk</a>",
            "<a class=\"govuk-link brand__color\" href=\"mailto:foiwales@walesoffice.gsi.gov.uk\">foiwales@walesoffice.gsi.gov.uk</a>",
          ],
          links: [
            "<a class=\"govuk-link brand__color\" href=\"/to/some/foi/stuff\">Click me</a>",
          ],
          description: "<p>FOI requests<br/><br/>are possible</p>",
        },
        {
          locale: "en",
          title: "Freedom of Information requests",
          post_addresses: [
            "The Welsh Office<br/>Green House<br/>Bracknell<br/>B2 3ZZ<br/>",
          ],
          phone_numbers: [],
          email_addresses: [
            "<a class=\"govuk-link brand__color\" href=\"mailto:welshofficefoi@walesoffice.gsi.gov.uk\">welshofficefoi@walesoffice.gsi.gov.uk</a>",
          ],
          links: [
            "<a class=\"govuk-link brand__color\" href=\"/foi/stuff\">FOI contact form</a>",
          ],
          description: "<p>Something here<br/><br/>Something there</p>",
        },
        {
          locale: "en",
          title: "Freedom of Information requests",
          post_addresses: [],
          phone_numbers: [],
          email_addresses: [],
          links: [],
          description: nil,
        },
      ]

      assert_equal expected, @contacts_presenter.foi_contacts
    end
  end

  describe "contacts" do
    before :each do
      content_item = ContentItem.new(organisation_with_contact_details)
      organisation = Organisation.new(content_item)
      @contacts_presenter = Organisations::ContactsPresenter.new(organisation)
    end

    it "formats contact information correctly" do
      expected = [
        {
          locale: "en",
          title: "Department for International Trade",
          post_addresses: [
            "King Charles Street<br/>Whitehall<br/>London<br/>SW1A 2AH<br/>United Kingdom<br/>",
          ],
          phone_numbers: [
            {
              title: "Custom Telephone",
              number: "+44 (0) 20 7215 5000",
            },
          ],
          email_addresses: [
            "<a class=\"govuk-link brand__color\" href=\"mailto:enquiries@trade.gov.uk\">enquiries@trade.gov.uk</a>",
          ],
          links: [
            "<a class=\"govuk-link brand__color\" href=\"/contact\">Contact Form: Department for International Trade</a>",
          ],
          description: nil,
        },
      ]

      assert_equal expected, @contacts_presenter.contacts
    end

    it "does not return empty address information" do
      content_item = ContentItem.new(organisation_with_empty_contact_details)
      organisation = Organisation.new(content_item)
      @empty_contacts_presenter = Organisations::ContactsPresenter.new(organisation)

      expected = [
        {
          locale: "en",
          title: "Department for International Trade",
          post_addresses: [nil],
          phone_numbers: [],
          email_addresses: [],
          links: [],
          description: nil,
        },
      ]

      assert_equal expected, @empty_contacts_presenter.contacts
    end
  end
end
