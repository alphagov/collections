require "integration_spec_helper"

RSpec.feature "Role page" do
  include SearchApiHelpers

  context "with the GraphQL feature flag" do
    before do
      enable_graphql_feature_flag
      stub_publishing_api_graphql_query(
        Graphql::RoleQuery.new("/government/ministers/prime-minister").query,
        role_edition_data,
      )
      stub_search(body: { results: [] })
    end

    let(:role_edition_data) do
      fetch_graphql_fixture("prime_minister")
    end

    context "when there is no GraphQL parameter" do
      before do
        visit "/government/ministers/prime-minister"
      end

      it "renders the page successfully" do
        expect(page).to have_selector("h1", text: "Prime Minister")
      end

      it "gets the data from GraphQL" do
        expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).to have_been_made
      end

      context "when there's a current role holder" do
        let(:role_edition_data) do
          fetch_graphql_fixture("prime_minister")
            .tap do |fixture|
              any_current = fixture["data"]["edition"]["links"]["role_appointments"]
                .any? { |ra| ra["details"]["current"] == true }

              unless any_current
                links = fixture["data"]["edition"]["links"]
                links["role_appointments"][0]["details"]["current"] = true
              end
            end
        end

        it "renders the page successfully" do
          expect(page.status_code).to eq(200)
        end
      end

      context "when there isn't a current role holder" do
        let(:role_edition_data) do
          fetch_graphql_fixture("prime_minister")
            .tap do |fixture|
              current = fixture["data"]["edition"]["links"]["role_appointments"]
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
        let(:role_edition_data) do
          fetch_graphql_fixture("prime_minister")
            .tap do |fixture|
              fixture["data"]["edition"]["details"]["supports_historical_accounts"] = true
            end
        end

        it "renders the page successfully" do
          expect(page.status_code).to eq(200)
        end
      end

      context "when the role doesn't 'support historical accounts'" do
        let(:role_edition_data) do
          fetch_graphql_fixture("prime_minister")
            .tap do |fixture|
              fixture["data"]["edition"]["details"]["supports_historical_accounts"] = false
            end
        end

        it "renders the page successfully" do
          expect(page.status_code).to eq(200)
        end
      end
    end

    context "when the GraphQL parameter is true" do
      before do
        visit "/government/ministers/prime-minister?graphql=true"
      end

      it "gets the data from GraphQL" do
        expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).to have_been_made
      end
    end

    context "when the GraphQL parameter is false" do
      before do
        stub_content_store_has_item(
          "/government/ministers/prime-minister",
          role_content_item_data,
        )
        stub_search(body: { results: [] })

        visit "/government/ministers/prime-minister?graphql=false"
      end

      let(:role_content_item_data) do
        GovukSchemas::Example.find("role", example_name: "prime_minister")
      end

      it "does not get data from GraphQL" do
        puts Plek.find("content-store")
        expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
      end
    end
  end

  context "without the GraphQL feature flag" do
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

    context "when there is no GraphQL parameter" do
      it "renders the page successfully" do
        expect(page).to have_selector("h1", text: "Prime Minister")
      end

      it "does not get data from GraphQL" do
        puts Plek.find("content-store")
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
        enable_graphql_feature_flag
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
    end

    context "when the GraphQL parameter is false" do
      before do
        visit "/government/ministers/prime-minister?graphql=false"
      end

      it "does not get data from GraphQL" do
        puts Plek.find("content-store")
        expect(a_request(:post, "#{Plek.find('publishing-api')}/graphql")).not_to have_been_made
      end
    end
  end
end
