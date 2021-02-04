require "test_helper"
require_relative "../../test/support/coronavirus_helper"

describe TaxonsController do
  include SearchApiHelpers
  include GovukAbTesting::MinitestHelpers
  include TaxonHelpers

  describe "GET show" do
    before do
      stub_content_store_has_item(taxon["base_path"], taxon)
      stub_content_for_taxon(taxon["content_id"], [taxon])
      stub_content_for_taxon(taxon["content_id"], generate_search_results(5))
      stub_document_types_for_supergroup("guidance_and_regulation")
      stub_most_popular_content_for_taxon(taxon["content_id"], tagged_content_for_guidance_and_regulation, filter_content_store_document_type: "guidance_and_regulation")
      stub_document_types_for_supergroup("services")
      stub_most_popular_content_for_taxon(taxon["content_id"], tagged_content_for_services, filter_content_store_document_type: "services")
      stub_document_types_for_supergroup("news_and_communications")
      stub_most_recent_content_for_taxon(taxon["content_id"], tagged_content_for_news_and_communications, filter_content_store_document_type: "news_and_communications")
      stub_document_types_for_supergroup("policy_and_engagement")
      stub_most_recent_content_for_taxon(taxon["content_id"], tagged_content_for_policy_and_engagement, filter_content_store_document_type: "policy_and_engagement")
      stub_document_types_for_supergroup("transparency")
      stub_most_recent_content_for_taxon(taxon["content_id"], tagged_content_for_transparency, filter_content_store_document_type: "transparency")
      stub_document_types_for_supergroup("research_and_statistics")
      stub_most_recent_content_for_taxon(taxon["content_id"], tagged_content_for_research_and_statistics, filter_content_store_document_type: "research_and_statistics")
      stub_organisations_for_taxon(taxon["content_id"], tagged_organisations)
    end
  end

  context "when rendering a taxon in the alpha phase" do
    before do
      stub_content_store_has_item(
        taxon["base_path"],
        taxon.merge("phase" => "alpha"),
      )
    end

    it do
      get :show, params: { taxon_base_path: taxon["base_path"][1..-1] }

      assert_response 404
    end
  end
end
