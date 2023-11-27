RSpec.describe Organisations::DocumentsPresenter do
  include SearchApiHelpers
  include OrganisationHelpers

  describe "documents" do
    let(:documents) { organisation_with_featured_documents["details"]["ordered_featured_documents"] }
    let(:documents_of_no_10) { organisation_with_featured_documents_and_is_no_10["details"]["ordered_featured_documents"] }
    let(:documents_presenter) { presenter_from_organisation_hash(organisation_with_featured_documents) }
    let(:documents_presenter_with_missing_urls) { presenter_from_organisation_hash(organisation_with_featured_documents_and_missing_urls) }
    let(:documents_presenter_no_10) { presenter_from_organisation_hash(organisation_with_featured_documents_and_is_no_10) }
    let(:no_documents_presenter) { presenter_from_organisation_hash(organisation_with_no_documents) }

    before do
      stub_empty_search_api_requests("org-with-no-docs")
      stub_search_api_latest_content_requests("attorney-generals-office")
    end

    context "page is No. 10 organisation page" do
      it "formats news stories correctly" do
        time_stamps = [
          documents_of_no_10[0]["public_updated_at"],
          documents_of_no_10[1]["public_updated_at"],
        ]

        expected = [
          {
            href: "/government/news/new-head-of-the-serious-fraud-office-announced",
            image_src: "https://assets.publishing.service.gov.uk/media/s465_asset_manager_id/s465_jeremy.jpg",
            image_alt: "Attorney General Jeremy Wright QC MP",
            context: {
              date: Date.parse(time_stamps[0]),
              text: "Press release",
            },
            heading_text: "New head of the Serious Fraud Office announced",
            description: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
            brand: "prime-ministers-office-10-downing-street",
            large: true,
            font_size: "s",
            heading_level: 3,
          },
          {
            href: "/government/news/new-head-of-a-different-office-announced",
            image_src: "https://assets.publishing.service.gov.uk/media/s465_asset_manager_id/s465_john.jpg",
            image_alt: "John Someone MP",
            context: {
              date: Date.parse(time_stamps[1]),
              text: "Policy paper",
            },
            heading_text: "New head of a different office announced",
            description: "John Someone appointed new Director of the Other Office ",
            brand: "prime-ministers-office-10-downing-street",
            heading_level: 3,
            large: true,
            font_size: "s",
          },
        ]
        expect(documents_presenter_no_10.remaining_featured_news).to eq(expected)
      end
    end

    it "formats the main large news story correctly" do
      time_stamp = documents.first["public_updated_at"]
      expected = {
        href: "/government/news/new-head-of-the-serious-fraud-office-announced",
        image_src: "https://assets.publishing.service.gov.uk/media/s712_asset_manager_id/s712_jeremy.jpg",
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
      expect(documents_presenter.first_featured_news).to eq(expected)
    end

    it "formats the main large news story with url field when high_resolution_url is not provided" do
      expected = "https://assets.publishing.service.gov.uk/media/original_asset_manager_id/jeremy.jpg"

      expect(documents_presenter_with_missing_urls.first_featured_news[:image_src]).to eq(expected)
    end

    it "formats the remaining news stories correctly" do
      time_stamp = documents.last["public_updated_at"]
      expected = [{
        href: "/government/news/new-head-of-a-different-office-announced",
        image_src: "https://assets.publishing.service.gov.uk/media/s465_asset_manager_id/s465_john.jpg",
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
      expect(documents_presenter.remaining_featured_news).to eq(expected)
    end

    it "formats the remaining news stories with url field when medium_resolution_url is not provided" do
      expected = "https://assets.publishing.service.gov.uk/media/original_asset_manager_id/john.jpg"

      expect(documents_presenter_with_missing_urls.remaining_featured_news.first[:image_src]).to eq(expected)
    end

    it "returns true if there are latest documents" do
      expect(documents_presenter.has_latest_documents?).to be true
    end

    it "returns false if there are no latest documents" do
      expect(no_documents_presenter.has_latest_documents?).to be false
    end

    it "formats latest documents correctly" do
      expected =
        {
          items: [
            {
              link: {
                text: "Attorney General launches recruitment campaign for new Chief Inspector",
                path: "/government/news/attorney-general-launches-recruitment-campaign-for-new-chief-inspector",
                locale: "en",
              },
              metadata: {
                document_type: "Press release",
                public_updated_at: Date.parse("2020-07-26T23:15:09.000+00:00"),
                locale: {
                  document_type: false,
                  public_updated_at: false,
                },
              },
            },
          ],
          brand: "attorney-generals-office",
        }

      expect(documents_presenter.latest_documents).to eq(expected)
    end

    it "formats document types with acronyms correctly" do
      # This only applies to types containing "FOI" and "DFID"
      stub_search_api_latest_content_with_acronym("attorney-generals-office")

      expected = "Press release"
      actual = documents_presenter.latest_documents[:items].first[:metadata][:document_type]

      expect(actual).to eq(expected)
    end
  end

  it "formats promotional features data correctly" do
    documents_presenter = presenter_from_organisation_hash(organisation_with_promotional_features)

    stub_search_api_latest_content_requests("prime-ministers-office-10-downing-street")

    expected = [
      {
        title: "One feature",
        number_of_items: 1,
        child_column_class: nil,
        items: [
          {
            description: "Story 1-1",
            href: "https://www.gov.uk/government/policies/1-1",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/1-1.jpg",
            image_alt: "Image 1-1",
            youtube_video_id: nil,
            youtube_video_alt: nil,
            extra_details: [
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
            large: true,
            extra_details_no_indent: true,
          },
        ],
      },
      {
        title: "Two features",
        number_of_items: 2,
        child_column_class: "govuk-grid-column-one-half",
        items: [
          {
            description: "Story 2-1",
            href: "https://www.gov.uk/government/policies/2-1",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/2-1.jpg",
            image_alt: "Image 2-1",
            youtube_video_id: nil,
            youtube_video_alt: nil,
            extra_details: [
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
            extra_details_no_indent: true,
          },
          {
            description: "Story 2-2",
            href: "https://www.gov.uk/government/policies/2-2",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/2-2.jpg",
            image_alt: "Image 2-2",
            youtube_video_id: nil,
            youtube_video_alt: nil,
            extra_details: [
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
            extra_details_no_indent: true,
          },
        ],
      },
      {
        title: "Three features",
        number_of_items: 3,
        child_column_class: "govuk-grid-column-one-third",
        items: [
          {
            description: "Story 3-1<br/><br/>And a new line",
            href: "https://www.gov.uk/government/policies/3-1",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/3-1.jpg",
            image_alt: "Image 3-1",
            youtube_video_id: nil,
            youtube_video_alt: nil,
            extra_details: [
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
            extra_details_no_indent: true,
          },
          {
            description: "Story 3-2",
            href: "https://www.gov.uk/government/policies/3-3",
            image_src: "https://assets.publishing.service.gov.uk/government/uploads/3-2.jpg",
            image_alt: "Image 3-2",
            youtube_video_id: nil,
            youtube_video_alt: nil,
            extra_details: [
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
            extra_details_no_indent: true,
          },
          {
            description: "Story 3-3",
            href: "https://www.gov.uk/government/policies/3-3",
            image_src: nil,
            image_alt: nil,
            youtube_video_id: "fFmDQn9Lbl4",
            youtube_video_alt: "YouTube video alt text.",
            heading_text: "An unexpected title",
            extra_details: [
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
            extra_details_no_indent: true,
          },
        ],
      },
    ]

    expect(documents_presenter.promotional_features).to eq(expected)
  end

  def presenter_from_organisation_hash(content)
    content_item = ContentItem.new(content)
    organisation = Organisation.new(content_item)
    described_class.new(organisation)
  end
end
