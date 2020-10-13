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

    describe "TransitionUrgency3 AB test" do
      context "Changes to bucket display in the en locale" do
        %w[A Z].each do |variant|
          it "#{variant} shows the default" do
            with_variant TransitionUrgency3: variant do
              get :show
              assert_select ".govuk-heading-m", text: "Businesses that import and export goods"
            end
          end
        end

        it "A shows the default" do
          with_variant TransitionUrgency3: "B" do
            get :show
            assert_select ".landing-page__buckets .govuk-body", text: "You need to take action now if you're:"
            assert_select ".landing-page__buckets li a", href: "/prepare-to-import-to-great-britain-from-january-2021", text: "importing goods into the UK"
            assert_select ".landing-page__buckets a", href: "/transition-check/questions", text: "Get the complete list"
          end
        end
      end

      context "In the cy locale" do
        %w[A B Z].each do |variant|
          it "displays the control text for the #{variant} variant" do
            setup_ab_variant("TransitionUrgency3", variant)

            get :show, params: { locale: "cy" }

            assert_response_not_modified_for_ab_test("TransitionUrgency2")
            assert_select ".govuk-heading-m", text: "Teithio i’r UE"
            assert_select ".landing-page__buckets .govuk-body", text: "You need to take action now if you're:", count: 0
          end
        end
      end
    end
  end
end
