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
        with_variant TransitionChecker2: "A" do
          get :show
          assert_select ".landing-page__guidance_subheader", text: "Actions you can take now that do not depend on negotiations."
          assert_select ".landing-page__guidance_subheader", text: "These are some of the new rules from January 2021. For a complete list of actions answer a few questions about you, your family or business.", count: 0
        end
      end
    end

    it "shows the alternate text for the B variant in the en locale" do
      with_variant TransitionChecker2: "B" do
        get :show
        assert_select ".landing-page__guidance_subheader", text: "These are some of the new rules from January 2021. For a complete list of actions answer a few questions about you, your family or business."
        assert_select ".landing-page__guidance_subheader", text: "Actions you can take now that do not depend on negotiations.", count: 0
      end
    end

    %w[A B INVALID_VARIANT].each do |variant|
      it "displays the default text for the #{variant} variant in the cy locale" do
        setup_ab_variant("TransitionChecker2", variant)

        get :show, params: { locale: "cy" }

        assert_response_not_modified_for_ab_test("TransitionChecker1")
        assert_select ".landing-page__guidance_subheader", text: "Camau y gallwch eu cymryd nawr sydd ddim yn ddibynnol ar drafodaethau."
        assert_select ".landing-page__guidance_subheader", text: "These are some of the new rules from January 2021. For a complete list of actions answer a few questions about you, your family or business.", count: 0
      end
    end
  end
end
