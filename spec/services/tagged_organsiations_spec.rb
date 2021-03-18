require "test_helper"
require "./test/support/custom_assertions.rb"

describe TaggedOrganisations do
  describe "#fetch" do
    before do
      setup_stubbed_organisations
    end

    it "return tagged organisations" do
      search_results = {
        "results" => [],
        "aggregates" => {
          "organisations" => {
            "options" => [{
              "value" => {
                "title" => "Department for Education",
                "content_id" => "ebd15ade-73b2-4eaf-b1c3-43034a42eb37",
                "link" => "/government/organisations/department-for-education",
                "slug" => "department-for-education",
                "organisation_state" => "live",
              },
              "documents" => 89,
            }],
          },
        },
      }

      Services.search_api.stubs(:search).returns(search_results)

      organisations = tagged_organisations.fetch
      assert_equal(1, organisations.count)
      assert_equal("Department for Education", organisations.first.title)
      assert_equal(89, organisations.first.document_count)
    end

    it "only returns live organisations" do
      search_results = {
        "aggregates" => {
          "organisations" => {
            "options" => [
              {
                "value" => {
                  "organisation_state" => "live",
                },
              },
              {
                "value" => {
                  "organisation_state" => "closed",
                },
              },
            ],
          },
        },
      }

      Services.search_api.stubs(:search).returns(search_results)

      organisations = tagged_organisations.fetch
      assert_equal(1, organisations.count)
    end
  end

private

  def taxon_content_id
    "c3c860fc-a271-4114-b512-1c48c0f82564"
  end

  def tagged_organisations
    @tagged_organisations ||= TaggedOrganisations.new(taxon_content_id)
  end

  def setup_stubbed_organisations
    search_results = {
      "results" => [],
      "aggregates" => {
        "organisations" => {
          "options" => [
            {
              "value" => {
                "title" => "Department for Education",
                "content_id" => "ebd15ade-73b2-4eaf-b1c3-43034a42eb37",
                "link" => "/government/organisations/department-for-education",
                "slug" => "department-for-education",
                "organisation_state" => "live",
              },
              "documents" => 89,
            },
            {
              "value" => {
                "title" => "Department for Education",
                "content_id" => "ebd15ade-73b2-4eaf-b1c3-43034a42eb37",
                "link" => "/government/organisations/department-for-education",
                "slug" => "department-for-education",
                "organisation_state" => "closed",
              },
              "documents" => 89,
            },
          ],
        },
      },
    }

    Services.search_api.stubs(:search).returns(search_results)
  end
end
