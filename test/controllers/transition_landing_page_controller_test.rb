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

    describe "TransitionUrgency2 AB test" do
      context "Bucket section header test in the en locale" do
        %w[A B Z].each do |variant|
          it "displays the winning text for the #{variant} variant" do
            with_variant TransitionUrgency2: variant do
              get :show
              assert_select ".govuk-heading-l", text: "Changes for businesses and citizens"
            end
          end
        end
      end

      context "In the cy locale" do
        %w[A B Z].each do |variant|
          it "displays the control text for the #{variant} variant" do
            setup_ab_variant("TransitionUrgency2", variant)

            get :show, params: { locale: "cy" }

            assert_response_not_modified_for_ab_test("TransitionUrgency2")
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
