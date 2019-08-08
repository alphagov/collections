require "test_helper"

describe BrexitLandingPageController do
  include RummagerHelpers
  include GovukAbTesting::MinitestHelpers
  include TaxonHelpers

  describe "GET show" do
    before do
      brexit_taxon = taxon
      brexit_taxon['base_path'] = '/government/brexit'
      content_store_has_item(brexit_taxon["base_path"], brexit_taxon)
      stub_content_for_taxon(brexit_taxon["content_id"], [brexit_taxon])
      stub_content_for_taxon(brexit_taxon["content_id"], generate_search_results(5))
      stub_document_types_for_supergroup('guidance_and_regulation')
      stub_most_popular_content_for_taxon(brexit_taxon["content_id"], tagged_content_for_guidance_and_regulation, filter_content_store_document_type: 'guidance_and_regulation')
      stub_document_types_for_supergroup('services')
      stub_most_popular_content_for_taxon(brexit_taxon["content_id"], tagged_content_for_services, filter_content_store_document_type: 'services')
      stub_document_types_for_supergroup('news_and_communications')
      stub_most_recent_content_for_taxon(brexit_taxon["content_id"], tagged_content_for_news_and_communications, filter_content_store_document_type: 'news_and_communications')
      stub_document_types_for_supergroup('policy_and_engagement')
      stub_most_recent_content_for_taxon(brexit_taxon["content_id"], tagged_content_for_policy_and_engagement, filter_content_store_document_type: 'policy_and_engagement')
      stub_document_types_for_supergroup('transparency')
      stub_most_recent_content_for_taxon(brexit_taxon["content_id"], tagged_content_for_transparency, filter_content_store_document_type: 'transparency')
      stub_document_types_for_supergroup('research_and_statistics')
      stub_most_recent_content_for_taxon(brexit_taxon["content_id"], tagged_content_for_research_and_statistics, filter_content_store_document_type: 'research_and_statistics')
      stub_organisations_for_taxon(brexit_taxon["content_id"], tagged_organisations)
    end

    it "renders the page" do
      get :show

      assert_response :success
    end
  end
end
