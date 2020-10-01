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

    %w[A Z].each do |variant|
      it "displays the default page header for the #{variant} variant in the en locale" do
        with_variant TransitionUrgency1: variant do
          get :show
          assert_select "h1", text: "The UK transition"
          assert_select "h1", text: "The transition period ends in December", count: 0
        end
      end

      it "displays the default take action title for the #{variant} variant in the en locale" do
        with_variant TransitionUrgency1: variant do
          get :show
          assert_select "h2", text: "Take action"
          assert_select "h2", text: "Make sure you're ready", count: 0
        end
      end
    end

    it "displays the value of take_action_title_variant_B for the B variant in the en locale" do
      with_variant TransitionUrgency1: "B" do
        get :show
        assert_select "h2", text: "Make sure you're ready"
        assert_select "h2", text: "Take action", count: 0
      end
    end

    it "displays the value of page_header_variant_B for the B variant in the en locale" do
      with_variant TransitionUrgency1: "B" do
        get :show
        assert_select "h1", text: "The transition period ends in December"
        assert_select "h1", text: "The UK transition", count: 0
      end
    end

    %w[A B Z].each do |variant|
      it "displays the control text for the #{variant} variant in the cy locale" do
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
