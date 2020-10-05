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
      context "Page header test in the en locale" do
        it "A" do
          with_variant TransitionUrgency1: "A" do
            get :show
            assert_select "h1", text: "The UK transition"
            assert_select "h1", text: "The transition period ends in December", count: 0
          end
        end

        it "B" do
          with_variant TransitionUrgency1: "B" do
            get :show
            assert_select "h1", text: "The transition period ends in December"
            assert_select "h1", text: "The UK transition", count: 0
          end
        end

        it "Z" do
          with_variant TransitionUrgency1: "Z" do
            get :show
            assert_select "h1", text: "The UK transition"
            assert_select "h1", text: "The transition period ends in December", count: 0
          end
        end
      end

      context "Take action title test in the en locale" do
        it "A" do
          with_variant TransitionUrgency1: "A" do
            get :show
            assert_select "h2", text: "Take action"
            assert_select "h2", text: "Make sure you're ready", count: 0
          end
        end

        it "B" do
          with_variant TransitionUrgency1: "B" do
            get :show
            assert_select "h2", text: "Make sure you're ready"
            assert_select "h2", text: "Take action", count: 0
          end
        end

        it "Z" do
          with_variant TransitionUrgency1: "Z" do
            get :show
            assert_select "h2", text: "Take action"
            assert_select "h2", text: "Make sure you're ready", count: 0
          end
        end
      end

      context "Take action summary text test in the en locale" do
        let(:default) do
          "Answer a few questions to get a personalised list of actions for you, your family, and your business. Then sign up for emails to get updates when things change."
        end
        let(:variant) do
          "Your business, family, and personal circumstances with be affected. Answer a few questions to get a personalised list of actions. You can also sign up for emails to get updates for what you need to do."
        end
        let(:summary_text) { "p.take_action_test_class" }

        it "A" do
          with_variant TransitionUrgency1: "A" do
            get :show
            assert_select summary_text, text: default
            assert_select summary_text, text: variant, count: 0
          end
        end

        it "B" do
          with_variant TransitionUrgency1: "B" do
            get :show
            assert_select summary_text, text: variant
            assert_select summary_text, text: default, count: 0
          end
        end

        it "Z" do
          with_variant TransitionUrgency1: "Z" do
            get :show
            assert_select summary_text, text: default
            assert_select summary_text, text: variant, count: 0
          end
        end
      end

      context "Brexit countdown clock test in the en locale" do
        it "A" do
          with_variant TransitionUrgency1: "A" do
            get :show
            assert_template partial: "_countdown", count: 0
            assert_template partial: "_take-action-traffic-lights", count: 1
          end
        end

        it "B" do
          with_variant TransitionUrgency1: "B" do
            get :show
            assert_template partial: "_countdown", count: 1
            assert_template partial: "_take-action-traffic-lights", count: 1
          end
        end

        it "Z" do
          with_variant TransitionUrgency1: "Z" do
            get :show
            assert_template partial: "_countdown", count: 0
            assert_template partial: "_take-action-traffic-lights", count: 1
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
