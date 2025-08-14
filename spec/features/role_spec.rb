require "integration_spec_helper"

RSpec.feature "Role page" do
  include SearchApiHelpers

  before do
    stub_content_store_has_item(
      base_path,
      role_content_item_data,
    )
    stub_search(body: { results: [] })

    allow(Random).to receive(:rand).with(1.0).and_return(1)
    visit base_path
  end

  let(:base_path) { role_content_item_data["base_path"] }

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
    before do
      allow(Random).to receive(:rand).with(1.0).and_return(1)
    end

    it "renders the page successfully" do
      expect(page).to have_selector("h1", text: "Prime Minister")
    end

    it "does not get data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).not_to have_been_made
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
      stub_publishing_api_graphql_has_item(base_path, role_content_item_data)
      stub_search(body: { results: [] })

      visit "#{base_path}?graphql=true"
    end

    it "gets the data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).to have_been_made
    end
  end

  context "when the GraphQL parameter is false" do
    before do
      visit "#{base_path}?graphql=false"
    end

    it "does not get data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).not_to have_been_made
    end
  end

  context "when the GraphQL A/B Content Store variant is selected" do
    before do
      allow(Random).to receive(:rand).with(1.0).and_return(1)
      visit base_path
    end

    it "does not get the data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).not_to have_been_made
    end
  end

  context "when the GraphQL A/B GraphQL variant is selected" do
    before do
      stub_publishing_api_graphql_has_item(base_path, role_content_item_data)

      allow(Random).to receive(:rand).with(1.0).and_return(RolesController::GRAPHQL_TRAFFIC_RATE - 0.000001)
      visit base_path
    end

    it "gets the data from GraphQL" do
      expect(a_request(:get, "#{Plek.find('publishing-api')}/graphql/content#{base_path}")).to have_been_made
    end
  end
end
