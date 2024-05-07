RSpec.describe PromotionalFeatureHelper do
  include OrganisationHelpers
  include PromotionalFeatureHelper
  attr_reader :org

  context "with both types of promotional features" do
    before do
      stub_search_api_latest_content_requests("prime-ministers-office-10-downing-street")
    end

    let!(:org) { Organisation.new(ContentItem.new(organisation_with_promotional_features)) }

    describe "#promotional_features" do
      it "formats promotional features data correctly" do
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
                image_src: nil,
                image_alt: nil,
                youtube_video_id: "fFmDQn9Lbl4",
                youtube_video_alt: "YouTube video alt text.",
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
                image_src: "https://assets.publishing.service.gov.uk/government/uploads/3-3.jpg",
                image_alt: "Image 3-3",
                youtube_video_id: nil,
                youtube_video_alt: nil,
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

        expect(promotional_features).to eq(expected)
      end
    end

    describe "#has_promotional_features?" do
      it "returns true" do
        expect(has_promotional_features?).to be true
      end
    end

    describe "#promotional_image_features" do
      it "returns the features minus the video feature" do
        expect(promotional_image_features.count).to eq(2)
      end
    end

    describe "#has_promotional_video_feature?" do
      it "returns true" do
        expect(has_promotional_video_feature?).to be true
      end
    end

    describe "#promotional_video_feature_youtube_url" do
      it "returns the url" do
        expect(promotional_video_feature_youtube_url).to eq("https://www.youtube.com/watch?v=fFmDQn9Lbl4")
      end
    end

    describe "#promotional_video_feature_title" do
      it "returns the url" do
        expect(promotional_video_feature_title).to eq("YouTube video alt text.")
      end
    end

    describe "#promotional_video_feature_item_links" do
      it "returns the links suitable for a document list component" do
        expected = [
          {
            text: "Single departmental plans",
            href: "https://www.gov.uk/government/collections/3-1",
          },
          {
            text: "Prime Minister's and Cabinet Office ministers' transparency publications",
            href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-1",
          },
        ]

        expect(promotional_video_feature_item_links).to eq(expected)
      end
    end
  end
end
