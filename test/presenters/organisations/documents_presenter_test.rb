require 'test_helper'

describe Organisations::DocumentsPresenter do
  include RummagerHelpers
  include OrganisationHelpers

  before :each do
    content_item = ContentItem.new(organisation_with_featured_documents)
    organisation = Organisation.new(content_item)
    @documents_presenter = Organisations::DocumentsPresenter.new(organisation)

    stub_rummager_latest_content_requests("attorney-generals-office")
  end

  it 'formats the main large news story correctly' do
    expected = {
      href: "/government/news/new-head-of-the-serious-fraud-office-announced",
      image_src: "https://assets.publishing.service.gov.uk/jeremy.jpg",
      image_alt: "Attorney General Jeremy Wright QC MP",
      context: "4 June 2018 — Press release",
      heading_text: "New head of the Serious Fraud Office announced",
      description: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
      brand: "attorney-generals-office",
      large: true
    }
    assert_equal expected, @documents_presenter.first_featured_news
  end

  it 'formats the remaining news stories correctly' do
    expected = [{
      href: "/government/news/new-head-of-a-different-office-announced",
      image_src: "https://assets.publishing.service.gov.uk/john.jpg",
      image_alt: "John Someone MP",
      context: "4 June 2017 — Policy paper",
      heading_text: "New head of a different office announced",
      description: "John Someone appointed new Director of the Other Office ",
      brand: "attorney-generals-office"
    }]
    assert_equal expected, @documents_presenter.remaining_featured_news
  end

  it 'formats latest documents correctly' do
    expected =
      {
        items: [
          {
            link: {
              text: "Rapist has sentence increased after Solicitor General’s referral",
              path: "/government/news/rapist-has-sentence-increased-after-solicitor-generals-referral"
            },
            metadata: {
              document_type: "Press release",
              public_updated_at: Date.parse("2018-06-18T17:39:34.000+01:00")
            }
          }
        ],
        brand: "attorney-generals-office"
      }

    assert_equal expected, @documents_presenter.latest_documents
  end

  it 'returns true if latest documents by type exist for an organisation' do
    assert @documents_presenter.has_latest_documents_by_type?
  end

  it 'returns false if no latest documents by type exist for an organisation' do
    stub_empty_rummager_requests("attorney-generals-office")

    assert_equal false, @documents_presenter.has_latest_documents_by_type?
  end

  it 'formats latest announcements correctly' do
    expected =
      {
        documents: {
          items: [
            {
              link: {
                text: "First events announced for National Democracy Week",
                path: "/government/news/first-events-announced-for-national-democracy-week"
              },
              metadata: {
                public_updated_at: Date.parse("2018-06-13T17:39:34.000+01:00"),
                document_type: "Press release"
              }
            },
            {
              link: {
                text: "See all announcements",
                path: "/government/announcements?departments%5B%5D=attorney-generals-office"
              }
            }
          ],
          brand: "attorney-generals-office"
        },
        title: "Our announcements"
      }

    assert_equal expected, @documents_presenter.latest_documents_by_type[0]
  end

  it 'formats latest consultations correctly' do
    expected =
      {
        documents: {
          items: [
            {
              link: {
                text: "Consultation on revised Code of Data Matching Practice",
                path: "/government/consultations/consultation-on-revised-code-of-data-matching-practice"
              },
              metadata: {
                public_updated_at: Date.parse("2018-04-27T17:39:34.000+01:00"),
                document_type: "Closed consultation"
              }
            },
            {
              link: {
                text: "See all consultations",
                path: "/government/consultations?departments%5B%5D=attorney-generals-office"
              }
            }
          ],
          brand: "attorney-generals-office"
        },
        title: "Our consultations"
      }

    assert_equal expected, @documents_presenter.latest_documents_by_type[1]
  end

  it 'formats latest publications correctly' do
    expected =
      {
        documents: {
          items: [
            {
              link: {
                text: "National Democracy Week: partner pack",
                path: "/government/publications/national-democracy-week-partner-pack"
              },
              metadata: {
                public_updated_at: Date.parse("2018-06-18T17:39:34.000+01:00"),
                document_type: "Guidance"
              }
            },
            {
              link: {
                text: "See all publications",
                path: "/government/publications?departments%5B%5D=attorney-generals-office"
              }
            }
          ],
          brand: "attorney-generals-office"
        },
        title: "Our publications"
      }

    assert_equal expected, @documents_presenter.latest_documents_by_type[2]
  end

  it 'does not include document types for which there are no latest documents' do
    # If documents do not exist for a certain document type (e.g: statistics), we don't want
    # statistics to be included at all in the latest_documents_by_type array. If the value were
    # [] or nil, this would break the layout as in_groups_of() treats [] or nil as an item in the group.

    assert_equal 3, @documents_presenter.latest_documents_by_type.length
  end
end
