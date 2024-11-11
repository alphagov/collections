require "integration_spec_helper"

RSpec.feature "Role page" do
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

  it "renders the page successfully" do
    expect(page).to have_selector("h1", text: "Prime Minister")
  end

  context "when there's a current role holder" do
    let(:role_content_item_data) do
      GovukSchemas::Example.find("role", example_name: "prime_minister")
        .tap do |example|
          none_current = example["links"]["role_appointments"]
            .all? { |ra| ra["details"]["current"] == false }

          if none_current
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
