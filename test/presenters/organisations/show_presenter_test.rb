require 'test_helper'

describe Organisations::ShowPresenter do
  include RummagerHelpers
  include OrganisationHelpers

  it 'adds a prefix to a title when it should' do
    content_item = ContentItem.new({ title: "Attorney General's Office" }.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "the Attorney General's Office"
    assert_equal expected, @show_presenter.prefixed_title
  end

  it 'does not add a prefix to a title when it should not' do
    content_item = ContentItem.new({ title: "The Charity Commission" }.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "The Charity Commission"
    assert_equal expected, @show_presenter.prefixed_title

    content_item = ContentItem.new({ title: "civil service resourcing" }.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "civil service resourcing"
    assert_equal expected, @show_presenter.prefixed_title
  end

  it 'formats policies correctly' do
    content_item = ContentItem.new(organisation_with_ministers)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = {
      items: [
        {
          link: {
            text: "Waste and recycling",
            path: "/government/policies/waste-and-recycling"
          }
        },
        {
          link: {
            text: "See all our policies",
            path: "/government/policies?organisations[]=attorney-generals-office"
          }
        }
      ],
      brand: "attorney-generals-office"
    }

    assert_equal expected, @show_presenter.featured_policies
  end

  it 'formats foi contacts correctly' do
    content_item = ContentItem.new(organisation_with_ministers)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = [
      {
        title: "FOI stuff",
        post_addresses: [
          "Office of the Secretary of State for Wales<br/>Gwydyr House<br/>Whitehall<br/>SW1A 2NP<br/>UK<br/>",
          "Office of the Secretary of State for Wales Cardiff<br/>White House<br/>Cardiff<br/>W1 3BZ<br/>"
        ],
        email_addresses: [
          "<a class=\"brand__color\" href=\"mailto:walesofficefoi@walesoffice.gsi.gov.uk\">walesofficefoi@walesoffice.gsi.gov.uk</a>",
          "<a class=\"brand__color\" href=\"mailto:foiwales@walesoffice.gsi.gov.uk\">foiwales@walesoffice.gsi.gov.uk</a>"
        ],
        description: "<p>FOI requests<br/><br/>are possible</p>"
      },
      {
        title: "Freedom of Information requests",
        post_addresses: [
          "The Welsh Office<br/>Green House<br/>Bracknell<br/>B2 3ZZ<br/>"
        ],
        email_addresses: [
          "<a class=\"brand__color\" href=\"mailto:welshofficefoi@walesoffice.gsi.gov.uk\">welshofficefoi@walesoffice.gsi.gov.uk</a>"
        ],
        description: "<p>Something here<br/><br/>Something there</p>"
      },
      {
        title: "Freedom of Information requests",
        post_addresses: [
          "Red House<br/>Slough<br/>S1 9NN<br/>"
        ],
        email_addresses: [],
        description: nil
      }
    ]

    assert_equal expected, @show_presenter.foi_contacts
  end
end
