require "test_helper"

describe Organisations::DocumentsPresenter do
  include RummagerHelpers
  include OrganisationHelpers

  describe "documents" do
    before :each do
      @documents = organisation_with_featured_documents["details"]["ordered_featured_documents"]
      content_item = ContentItem.new(organisation_with_featured_documents)
      organisation = Organisation.new(content_item)
      @documents_presenter = Organisations::DocumentsPresenter.new(organisation)

      content_item = ContentItem.new(organisation_with_no_documents)
      organisation = Organisation.new(content_item)
      @no_documents_presenter = Organisations::DocumentsPresenter.new(organisation)

      stub_empty_rummager_requests("org-with-no-docs")
      stub_rummager_latest_content_requests("attorney-generals-office")
    end

    it "formats the main large news story correctly" do
      time_stamp = @documents.first["public_updated_at"]
      expected = {
        href: "/government/news/new-head-of-the-serious-fraud-office-announced",
        image_src: "https://assets.publishing.service.gov.uk/s712_jeremy.jpg",
        image_alt: "Attorney General Jeremy Wright QC MP",
        context: {
          date: Date.parse(time_stamp),
          text: "Press release",
        },
        heading_text: "New head of the Serious Fraud Office announced",
        description: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
        brand: "attorney-generals-office",
        large: true,
        heading_level: 3,
      }
      assert_equal expected, @documents_presenter.first_featured_news
    end

    it "formats the remaining news stories correctly" do
      time_stamp = @documents.last["public_updated_at"]
      expected = [{
        href: "/government/news/new-head-of-a-different-office-announced",
        image_src: "https://assets.publishing.service.gov.uk/s465_john.jpg",
        image_alt: "John Someone MP",
        context: {
          date: Date.parse(time_stamp),
          text: "Policy paper",
        },
        heading_text: "New head of a different office announced",
        description: "John Someone appointed new Director of the Other Office ",
        brand: "attorney-generals-office",
        heading_level: 3,
      }]
      assert_equal expected, @documents_presenter.remaining_featured_news
    end

    it "returns true if there are latest documents" do
      assert @documents_presenter.has_latest_documents?
    end

    it "returns false if there are no latest documents" do
      assert_equal false, @no_documents_presenter.has_latest_documents?
    end

    it "formats latest documents correctly" do
      expected =
        {
          items: [
            {
              link: {
                text: "Rapist has sentence increased after Solicitor General’s referral",
                path: "/government/news/rapist-has-sentence-increased-after-solicitor-generals-referral",
                locale: "en",
              },
              metadata: {
                document_type: "Press release",
                public_updated_at: Date.parse("2018-06-18T17:39:34.000+01:00"),
                locale: {
                  document_type: false,
                  public_updated_at: false,
                },
              },
            },
          ],
          brand: "attorney-generals-office",
        }

      assert_equal expected, @documents_presenter.latest_documents
    end

    it "formats document types with acronyms correctly" do
      # This only applies to types containing "FOI" and "DFID"
      stub_rummager_latest_content_with_acronym("attorney-generals-office")

      expected = "Research for Development Output"
      actual = @documents_presenter.latest_documents[:items].first[:metadata][:document_type]

      assert_equal expected, actual
    end
  end

  it "formats promotional features data correctly" do
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
                href: "https://www.gov.uk/government/collections/1-1",
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/1-1",
              },
            ],
            brand: nil,
            heading_level: 3,
          },
        ],
      },
      {
        title: "Two features",
        number_of_items: 2,
        parent_column_class: "column-2",
        child_column_class: "govuk-grid-column-one-half",
        items: [
          {
            description: "Story 2-1",
            href: "https://www.gov.uk/government/policies/2-1",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/2-1.jpg",
            image_alt: "Image 2-1",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/2-1",
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/2-1",
              },
            ],
            brand: nil,
            heading_level: 3,
          },
          {
            description: "Story 2-2",
            href: "https://www.gov.uk/government/policies/2-2",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/2-2.jpg",
            image_alt: "Image 2-2",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/2-2",
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/2-2",
              },
            ],
            brand: nil,
            heading_level: 3,
          },
        ],
      },
      {
        title: "Three features",
        number_of_items: 3,
        parent_column_class: "column-3",
        child_column_class: "govuk-grid-column-one-third",
        items: [
          {
            description: "Story 3-1<br/><br/>And a new line",
            href: "https://www.gov.uk/government/policies/3-1",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/3-1.jpg",
            image_alt: "Image 3-1",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/3-1",
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-1",
              },
            ],
            brand: nil,
            heading_level: 3,
          },
          {
            description: "Story 3-2",
            href: "https://www.gov.uk/government/policies/3-3",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/3-2.jpg",
            image_alt: "Image 3-2",
            extra_links: [
              {
                text: "Single departmental plans",
                href: "https://www.gov.uk/government/collections/3-2",
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-2",
              },
            ],
            brand: nil,
            heading_level: 3,
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
                href: "https://www.gov.uk/government/collections/3-3",
              },
              {
                text: "Prime Minister's and Cabinet Office ministers' transparency publications",
                href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-3",
              },
            ],
            brand: nil,
            heading_level: 3,
          },
        ],
      },
    ]

    assert_equal expected, @documents_presenter.promotional_features
  end
end
