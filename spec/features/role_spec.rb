require "integration_spec_helper"

RSpec.feature "Role page" do
  include SearchApiHelpers

  before do
    stub_conditional_loader_returns_content_item_for_path(
      base_path,
      role_content_item_data,
    )
    stub_search(body: { results: [] })

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

  context "when the role page is requested" do
    it "renders the page successfully" do
      expect(page).to have_selector("h1", text: "Prime Minister")
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
end
