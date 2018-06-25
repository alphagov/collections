require 'test_helper'

describe Organisations::DocumentsPresenter do
  include RummagerHelpers
  include OrganisationHelpers

  describe 'documents' do
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
        large: true,
        heading_level: 3
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
        brand: "attorney-generals-office",
        heading_level: 3
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

  it 'formats promotional features data correctly' do
    content_item = ContentItem.new(organisation_with_promotional_features)
    organisation = Organisation.new(content_item)
    @documents_presenter = Organisations::DocumentsPresenter.new(organisation)

    stub_rummager_latest_content_requests("prime-ministers-office-10-downing-street")

    expected = [
      {
        title: "One feature",
        number_of_items: 1,
        parent_column_class: "column-1",
        child_column_class: nil,
        items: [
          {
            description: "Story 1-1",
            href: "https://www.gov.uk/government/policies/1-1",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/1-1.jpg",
            image_alt: "Image 1-1",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/1-1"
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/1-1"
              }
            ],
            brand: nil,
            heading_level: 3
          }
        ]
      },
      {
        title: "Two features",
        number_of_items: 2,
        parent_column_class: "column-2",
        child_column_class: "column-half",
        items: [
          {
            description: "Story 2-1",
            href: "https://www.gov.uk/government/policies/2-1",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/2-1.jpg",
            image_alt: "Image 2-1",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/2-1"
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/2-1"
              }
            ],
            brand: nil,
            heading_level: 3
          },
          {
            description: "Story 2-2",
            href: "https://www.gov.uk/government/policies/2-2",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/2-2.jpg",
            image_alt: "Image 2-2",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/2-2"
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/2-2"
              }
            ],
            brand: nil,
            heading_level: 3
          }
        ]
      },
      {
        title: "Three features",
        number_of_items: 3,
        parent_column_class: "column-3",
        child_column_class: "column-one-third",
        items: [
          {
            description: "Story 3-1<br/><br/>And a new line",
            href: "https://www.gov.uk/government/policies/3-1",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/3-1.jpg",
            image_alt: "Image 3-1",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/3-1"
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-1"
              }
            ],
            brand: nil,
            heading_level: 3
          },
          {
            description: "Story 3-2",
            href: "https://www.gov.uk/government/policies/3-3",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/3-2.jpg",
            image_alt: "Image 3-2",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/3-2"
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-2"
              }
            ],
            brand: nil,
            heading_level: 3
          },
          {
            description: "Story 3-3",
            href: "https://www.gov.uk/government/policies/3-3",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/3-3.jpg",
            image_alt: "Image 3-3",
            heading_text: "An unexpected title",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/3-3"
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-3"
              }
            ],
            brand: nil,
            heading_level: 3
          }
        ]
      }
    ]

    assert_equal expected, @documents_presenter.promotional_features
  end
end
