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

    %w[A INVALID_VARIANT].each do |variant|
      it "displays the default blue button for the #{variant} variant in the en locale" do
        with_variant TransitionChecker4: "A" do
          get :show
          assert_select "div.landing-page__take-action-button"
          assert_select "div.landing-page__take-action-button_variantB", count: 0
        end
      end
    end

    it "displays a red button for the B variant in the en locale" do
      with_variant TransitionChecker4: "B" do
        get :show
        assert_select "div.landing-page__take-action-button_variantB"
        assert_select "div.landing-page__take-action-button", count: 0
      end
    end

    %w[A B INVALID_VARIANT].each do |variant|
      it "displays the default blue button for the #{variant} variant in the cy locale" do
        setup_ab_variant("TransitionChecker4", variant)

        get :show, params: { locale: "cy" }

        assert_response_not_modified_for_ab_test("TransitionChecker3")
        assert_select "div.landing-page__take-action-button"
        assert_select "div.landing-page__take-action-button_variantB", count: 0
      end
    end
  end
end
