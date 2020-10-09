require "test_helper"

describe TransitionLandingPageController do
  include TaxonHelpers
  include GovukAbTesting::MinitestHelpers

  describe "GET show" do
    before do
      brexit_taxon = taxon
      brexit_taxon["base_path"] = "/transition"
      stub_content_store_has_item(brexit_taxon["base_path"], brexit_taxon)
      stub_content_store_has_item(brexit_taxon["base_path"] + ".cy", brexit_taxon)
    end

    %w[cy en].each do |locale|
      params = locale == "en" ? {} : { locale: locale }

      it "renders the page for the #{locale} locale" do
        get :show, params: params
        assert_response :success
      end
    end

    describe "TransitionUrgency1 AB test" do
      context "Bucket section header test in the en locale" do
        it "A" do
          with_variant TransitionUrgency1: "A" do
            get :show
            assert_select ".govuk-heading-l", text: "Actions you can take now"
            assert_select ".govuk-heading-l", text: "Changes for businesses and citizens", count: 0
          end
        end

        it "B" do
          with_variant TransitionUrgency1: "B" do
            get :show
            assert_select ".govuk-heading-l", text: "Changes for businesses and citizens"
            assert_select ".govuk-heading-l", text: "Actions you can take now", count: 0
          end
        end

        it "Z" do
          with_variant TransitionUrgency1: "Z" do
            get :show
            assert_select ".govuk-heading-l", text: "Actions you can take now"
          end
        end
      end

      context "Make sure that buckets appear in the expected order in the en locale" do
        it "A" do
          with_variant TransitionUrgency1: "A" do
            get :show
            assert_select ".landing-page__section-list-wrapper h3:first-of-type", text: "Travelling to the EU"
          end
        end

        it "B" do
          with_variant TransitionUrgency1: "B" do
            get :show
            assert_select ".landing-page__section-list-wrapper h3:first-of-type", text: "Businesses that import and export goods"
          end
        end

        it "Z" do
          with_variant TransitionUrgency1: "Z" do
            get :show
            assert_select ".landing-page__section-list-wrapper h3:first-of-type", text: "Travelling to the EU"
          end
        end
      end

      context "In the cy locale" do
        %w[A B Z].each do |variant|
          it "displays the control text for the #{variant} variant" do
            setup_ab_variant("TransitionUrgency1", variant)

            get :show, params: { locale: "cy" }

            assert_response_not_modified_for_ab_test("TransitionUrgency1")
            assert_select "h1", text: "Pontio’r DU"
            assert_select "h1", text: "The transition period ends in December", count: 0

            assert_select "h2", text: "Cymrwch y camau a chofrestru ar gyfer negeseuon e-bost"
            assert_select "h2", text: "Make sure you're ready", count: 0
          end
        end
      end
    end
  end
end
