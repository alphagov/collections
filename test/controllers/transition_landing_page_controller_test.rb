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
      it "displays the default text for the #{variant} variant in the en locale" do
        with_variant TransitionChecker3: "A" do
          get :show
          assert_select "h2", text: "Actions you can take now"
          assert_select "h2", text: "Some of the new rules for 2021", count: 0
        end
      end
    end

    it "shows the alternate text for the B variant in the en locale" do
      with_variant TransitionChecker3: "B" do
        get :show
        assert_select "h2", text: "Some of the new rules for 2021"
        assert_select "h2", text: "Actions you can take now", count: 0
      end
    end

    %w[A B INVALID_VARIANT].each do |variant|
      it "displays the default text for the #{variant} variant in the cy locale" do
        setup_ab_variant("TransitionChecker3", variant)

        get :show, params: { locale: "cy" }

        assert_response_not_modified_for_ab_test("TransitionChecker3")
        assert_select "h2", text: "Camau y gallwch eu cymryd nawr"
        assert_select "h2", text: "Some of the new rules for 2021", count: 0
      end
    end
  end
end
