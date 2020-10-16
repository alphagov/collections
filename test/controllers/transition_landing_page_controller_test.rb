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

    describe "TransitionUrgency4 AB test" do
      context "In the en locale" do
        %w[A Z].each do |variant|
          it "Variant #{variant} shows the default (video and announcements visible)" do
            with_variant TransitionUrgency4: variant do
              get :show
              assert_template partial: "_video_section", count: 1
              assert_template partial: "_comms", count: 1
            end
          end
        end

        it "Variant B hides the video and announcements" do
          with_variant TransitionUrgency4: "B" do
            get :show
            assert_template partial: "_video_section", count: 0
            assert_template partial: "_comms", count: 0
          end
        end
      end

      context "In the cy locale" do
        %w[A B Z].each do |variant|
          it "All variants shows the default (video and announcements visible)" do
            setup_ab_variant("TransitionUrgency4", variant)
            get :show, params: { locale: "cy" }
            assert_template partial: "_video_section", count: 1
            assert_template partial: "_comms", count: 1
          end
        end
      end
    end
  end
end
