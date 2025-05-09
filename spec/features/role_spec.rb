require "integration_spec_helper"

RSpec.feature "Role page" do
  include GovukAbTesting::RspecHelpers
  include SearchApiHelpers

  before do
    stub_content_store_has_item(
      "/government/ministers/prime-minister",
      role_content_item_data,
    )
    stub_search(body: { results: [] })

    visit "/government/ministers/prime-minister"
  end

  let(:role_content_item_data) do
    GovukSchemas::Example.find("role", example_name: "prime_minister")
  end

  context "when the ordered_parent_organisations links are nil" do
    let(:role_content_item_data) do
      GovukSchemas::Example.find("role", example_name: "prime_minister").tap do |content_item|
        content_item["links"]["ordered_parent_organisations"] = nil
      end
    end

    it "does not include the organisations list" do
      expect(page).to_not have_selector("div.organisations-list")
    end
  end

  context "when the ordered_parent_organisations links are an empty array" do
    let(:role_content_item_data) do
      GovukSchemas::Example.find("role", example_name: "prime_minister").tap do |content_item|
        content_item["links"]["ordered_parent_organisations"] = []
      end
    end

    it "does not include the organisations list" do
      expect(page).to_not have_selector("div.organisations-list")
    end
  end

  context "when the ordered_parent_organisations links are present" do
    it "includes the organisations list" do
      expect(page).to have_selector("div.organisations-list")
    end
  end

  context "when there is no GraphQL parameter" do
    it "renders the page successfully" do
      expect(page).to have_selector("h1", text: "Prime Minister")
    end

    it "does not get data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
    end

    context "when there's a current role holder" do
      let(:role_content_item_data) do
        GovukSchemas::Example.find("role", example_name: "prime_minister")
          .tap do |example|
            any_current = example["links"]["role_appointments"]
              .any? { |ra| ra["details"]["current"] == true }

            unless any_current
              example["links"]["role_appointments"][0]["details"]["current"] = true
            end
          end
      end

      it "renders the page successfully" do
        expect(page.status_code).to eq(200)
      end
    end

    context "when there isn't a current role holder" do
      let(:role_content_item_data) do
        GovukSchemas::Example.find("role", example_name: "prime_minister")
          .tap do |example|
            current = example["links"]["role_appointments"]
              .find { |ra| ra["details"]["current"] == true }

            if current
              current["details"]["current"] = false
              current["details"]["ended_on"] = Time.zone.now
            end
          end
      end

      it "renders the page successfully" do
        expect(page.status_code).to eq(200)
      end
    end

    context "when the role 'supports historical accounts'" do
      let(:role_content_item_data) do
        GovukSchemas::Example.find("role", example_name: "prime_minister")
          .tap do |example|
            example["details"]["supports_historical_accounts"] = true
          end
      end

      it "renders the page successfully" do
        expect(page.status_code).to eq(200)
      end
    end

    context "when the role doesn't 'support historical accounts'" do
      let(:role_content_item_data) do
        GovukSchemas::Example.find("role", example_name: "prime_minister")
          .tap do |example|
            example["details"]["supports_historical_accounts"] = false
          end
      end

      it "renders the page successfully" do
        expect(page.status_code).to eq(200)
      end
    end
  end

  context "when the GraphQL parameter is true" do
    before do
      stub_publishing_api_graphql_query(
        Graphql::RoleQuery.new("/government/ministers/prime-minister").query,
        role_edition_data,
      )
      stub_search(body: { results: [] })

      visit "/government/ministers/prime-minister?graphql=true"
    end

    let(:role_edition_data) do
      fetch_graphql_fixture("prime_minister")
    end

    it "gets the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).to have_been_made
    end

    it "renders the locale in <main> element" do
      expect(page).to have_css("main[lang='en']")
    end

    %w[
      govuk:content-id
      govuk:first-published-at
      govuk:format
      govuk:organisations
      govuk:public-updated-at
      govuk:publishing-app
      govuk:rendering-app
      govuk:schema-name
      govuk:taxon-id
      govuk:taxon-ids
      govuk:taxon-slug
      govuk:taxon-slugs
      govuk:updated-at
    ].each do |meta_tag_name|
      it "renders the #{meta_tag_name} meta tag" do
        meta_tag = page.first("meta[name='#{meta_tag_name}']", visible: false)
        expect(meta_tag["content"]).to be_present
      end
    end
  end

  context "when the GraphQL parameter is false" do
    before do
      visit "/government/ministers/prime-minister?graphql=false"
    end

    it "does not get data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
    end
  end

  context "when the GraphQL A/B A variant is selected" do
    before do
      with_variant GraphQLRoles: "A" do
        visit "/government/ministers/prime-minister"
      end
    end

    it "does not get the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
    end
  end

  context "when the GraphQL A/B test control is selected" do
    before do
      with_variant GraphQLRoles: "Z" do
        visit "/government/ministers/prime-minister"
      end
    end

    it "does not get the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
    end
  end

  context "when the GraphQL A/B B variant is selected" do
    before do
      stub_publishing_api_graphql_query(
        Graphql::RoleQuery.new("/government/ministers/prime-minister").query,
        role_edition_data,
      )

      with_variant GraphQLRoles: "B" do
        visit "/government/ministers/prime-minister"
      end
    end

    let(:role_edition_data) do
      fetch_graphql_fixture("prime_minister")
    end

    it "gets the data from GraphQL" do
      expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).to have_been_made
    end
  end
end
