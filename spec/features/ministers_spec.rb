require "integration_spec_helper"

RSpec.feature "Ministers index page" do
  include GovukAbTesting::RspecHelpers

  shared_examples "ministers index page" do
    scenario "returns 200 when visiting ministers page" do
      expect(page.status_code).to eq(200)
    end

    scenario "renders webpage title" do
      expect(page).to have_title(I18n.t("ministers.govuk_title"))
    end

    scenario "renders page title" do
      expect(page).to have_selector(".gem-c-heading__text", text: I18n.t("ministers.title"))
    end

    %w[
      govuk:content-id
      govuk:first-published-at
      govuk:format
      govuk:public-updated-at
      govuk:publishing-app
      govuk:rendering-app
      govuk:schema-name
      govuk:updated-at
    ].each do |meta_tag_name|
      it "renders the #{meta_tag_name} meta tag" do
        meta_tag = page.first("meta[name='#{meta_tag_name}']", visible: false)
        expect(meta_tag["content"]).to be_present
      end
    end

    it "renders the locale in <main> element" do
      expect(page).to have_css("main[lang='en']")
    end

    scenario "renders the lead paragraph with anchor links" do
      expect(page).to have_selector(".gem-c-lead-paragraph")
      within(".gem-c-lead-paragraph") do
        expect(page).to have_link("Cabinet ministers", href: "#cabinet-ministers", class: "govuk-link")
      end
    end

    scenario "renders section headers" do
      expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.cabinet"))
      expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.also_attends"))
      expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.by_department"))
      expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.whips"))
    end

    scenario "renders cabinet ministers in the relevant section" do
      within("#cabinet li", match: :first) do
        expect(page).to have_text("The Rt Hon")
        expect(page).to have_text("Rishi Sunak MP")
        expect(page).to have_text("Prime Minister, First Lord of the Treasury, Minister for the Civil Service, Minister for the Union")
      end
    end

    scenario "cabinet section shows ministers' role payment type info where required" do
      greg_hands = all("#cabinet li")[1]
      expect(greg_hands).to have_text("Greg Hands MP")
      expect(greg_hands).to have_text("Minister without Portfolio")
      expect(greg_hands).to have_text("Unpaid")
    end

    scenario "renders ministers who also attend cabinet in the relevant section" do
      within("#also-attends-cabinet li", match: :first) do
        expect(page).to have_text("The Rt Hon")
        expect(page).to have_text("Simon Hart MP")
        expect(page).to have_text("Parliamentary Secretary to the Treasury (Chief Whip)")
      end
    end

    scenario "also attends cabinet section shows ministers' role payment type info where required" do
      john_glen = all("#also-attends-cabinet li")[1]
      expect(john_glen).to have_text("John Glen MP")
      expect(john_glen).to have_text("Chief Secretary to the Treasury")
      expect(john_glen).to have_text("Unpaid")
    end

    scenario "renders whips by whip organisation in the relevant section" do
      within("#whip-house-of-commons") do
        expect(page).to have_text("House of Commons")
      end
    end

    scenario "the whip section shows only ministers' whip roles" do
      lord_caine = all("#whip-baronesses-and-lords-in-waiting li")[1]
      expect(lord_caine).to have_text("Lord Caine")
      expect(lord_caine).to have_text("Lord in Waiting")
      expect(lord_caine).to_not have_text("Parliamentary Under Secretary of State")
    end

    scenario "renders ministers by department in the relevant section" do
      cabinet_office = find("#cabinet-office")
      expect(cabinet_office).to have_text("Cabinet Office")
      expect(cabinet_office.find("li", match: :first)).to have_text("Rishi Sunak")
    end

    scenario "the ministers by department section show only ministers' roles within that department" do
      dbt = find("#department-for-business-and-trade")
      expect(dbt).to have_text("Business & Trade")
      kemi_badenoch_dbt = dbt.find("li", match: :first)
      expect(kemi_badenoch_dbt).to have_text("Kemi Badenoch")
      expect(kemi_badenoch_dbt).to have_text("Secretary of State for Business and Trade, President of the Board of Trade")

      uef = find("#uk-export-finance")
      expect(uef).to have_text("UK Export Finance")
      kemi_badenoch_uef = uef.find("li", match: :first)
      expect(kemi_badenoch_uef).to have_text("Kemi Badenoch")
      expect(kemi_badenoch_uef).to have_text("President of the Board of Trade")
      expect(kemi_badenoch_uef).to_not have_text("Secretary of State for Business and Trade")
    end

    scenario "the ministers by department section does not show departments without ministers appointed" do
      expect(page).not_to have_selector("#office-of-the-advocate-general-for-scotland")
      expect(page).not_to have_text("Office of the Advocate General for Scotland")
    end
  end

  shared_examples "ministers index page rendered from Content Store" do
    let(:document) { GovukSchemas::Example.find("ministers_index", example_name: "ministers_index-reshuffle-mode-off") }

    it "does not get the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
    end

    it_behaves_like "ministers index page"

    context "during a reshuffle" do
      let(:document) { GovukSchemas::Example.find("ministers_index", example_name: "ministers_index-reshuffle-mode-on") }

      it_behaves_like "ministers index page during a reshuffle"
    end

    context "during a reshuffle preview" do
      let(:document) { GovukSchemas::Example.find("ministers_index", example_name: "ministers_index-reshuffle-mode-on-preview") }

      it_behaves_like "ministers index page during a reshuffle preview"
    end
  end

  shared_examples "ministers index page rendered from GraphQL" do
    let(:document) { fetch_graphql_fixture("ministers_index-reshuffle-mode-off") }

    scenario "returns 200 when visiting ministers page" do
      expect(page.status_code).to eq(200)
    end

    it "gets the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).to have_been_made
    end

    it_behaves_like "ministers index page"
  end

  shared_examples "ministers index page during a reshuffle" do
    scenario "renders the reshuffle messaging instead of the usual contents" do
      within(".gem-c-notice") do
        expect(page).to have_text("Check latest appointments")
        expect(page).to have_link("latest appointments", href: "/government/news/ministerial-appointments-february-2023", class: "govuk-link")
      end
      expect(page).not_to have_selector(".gem-c-lead-paragraph")
      expect(page).not_to have_selector(".gem-c-heading", text: I18n.t("ministers.cabinet"))
      expect(page).not_to have_selector(".gem-c-heading", text: I18n.t("ministers.also_attends"))
      expect(page).not_to have_selector(".gem-c-heading", text: I18n.t("ministers.by_department"))
      expect(page).not_to have_selector(".gem-c-heading", text: I18n.t("ministers.whips"))
    end
  end

  shared_examples "ministers index page during a reshuffle preview" do
    scenario "renders the sections and contents even with empty roles sets" do
      expect(page.status_code).to eq(200)
      expect(page).to have_selector(".gem-c-lead-paragraph")
      expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.cabinet"))
      expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.also_attends"))
      expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.by_department"))
      expect(page).to have_selector(".gem-c-heading", text: I18n.t("ministers.whips"))
    end
  end

  before do
    stub_content_store_has_item("/government/ministers", document)
  end

  context "when the GraphQL parameter is not set" do
    before do
      visit "/government/ministers"
    end

    it_behaves_like "ministers index page rendered from Content Store"
  end

  context "when the GraphQL parameter is true" do
    before do
      stub_publishing_api_graphql_query(
        Graphql::MinistersIndexQuery.new("/government/ministers").query,
        document,
      )

      visit "/government/ministers?graphql=true"
    end

    it_behaves_like "ministers index page rendered from GraphQL"
  end

  context "when the GraphQL parameter is false" do
    before do
      visit "/government/ministers?graphql=false"
    end

    it_behaves_like "ministers index page rendered from Content Store"
  end

  context "when the GraphQL A/B A variant is selected" do
    before do
      with_variant GraphQLMinistersIndex: "A" do
        visit "/government/ministers"
      end
    end

    it_behaves_like "ministers index page rendered from Content Store"
  end

  context "when the GraphQL A/B test control is selected" do
    before do
      with_variant GraphQLMinistersIndex: "Z" do
        visit "/government/ministers"
      end
    end

    it_behaves_like "ministers index page rendered from Content Store"
  end

  context "when the GraphQL A/B B variant is selected" do
    before do
      stub_publishing_api_graphql_query(
        Graphql::MinistersIndexQuery.new("/government/ministers").query,
        document,
      )

      with_variant GraphQLMinistersIndex: "B" do
        visit "/government/ministers"
      end
    end

    it_behaves_like "ministers index page rendered from GraphQL"
  end
end
