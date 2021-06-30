module CoronavirusContentItemHelper
  CORONAVIRUS_TAXON_PATH = "/coronavirus-taxons".freeze

  def coronavirus_landing_page_content_item
    load_content_item("coronavirus_landing_page.json")
  end

  def load_content_item(file_name)
    json = File.read(
      Rails.root.join("spec/fixtures/content_store/", file_name),
    )
    JSON.parse(json)
  end

  def business_content_item_fixture
    load_content_item("business_support_page.json")
  end

  def education_content_item_fixture
    load_content_item("coronavirus_education_page.json")
  end

  def stub_coronavirus_statistics
    body = { data: [{ "date" => "2021-03-18",
                      "cumulativeVaccinations" => 25_000_000,
                      "hospitalAdmissions" => 1000,
                      "newPositiveTests" => 5000 }] }

    stub_request(:get, /coronavirus.data.gov.uk/).to_return(status: 200, body: body.to_json)
  end

  def random_landing_page(&block)
    GovukSchemas::RandomExample.for_schema(frontend_schema: "coronavirus_landing_page", &block)
  end

  def coronavirus_content_item
    random_landing_page do |item|
      item.merge(coronavirus_landing_page_content_item)
    end
  end

  def coronavirus_content_item_with_risk_level_element_enabled
    content_item = coronavirus_content_item
    content_item["details"]["risk_level"]["show_risk_level_section"] = true
    content_item
  end

  def business_content_item
    random_landing_page do |item|
      item.merge(business_content_item_fixture)
    end
  end

  def coronavirus_content_item_with_timeline_national_applicability
    load_content_item("coronavirus_landing_page_with_timeline_nations.json")
  end

  def coronavirus_content_item_with_timeline_national_applicability_without_wales
    load_content_item("coronavirus_landing_page_with_timeline_nations_without_wales.json")
  end

  def random_taxon_page
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      yield(item) if block_given?
      item["phase"] = "live"
      item
    end
  end

  def business_taxon_content_item
    random_taxon_page do |item|
      item["content_id"] = TaxonsRedirectionController::HUB_PAGE_FROM_CONTENT_ID.key("/coronavirus/business-support")
      item
    end
  end

  def business_subtaxon_content_item
    stubbed_business_taxon = business_taxon_content_item.tap do |item|
      item["links"] = {}
    end

    random_taxon_page do |item|
      item["links"]["parent_taxons"] = [stubbed_business_taxon]
      item
    end
  end

  def other_subtaxon_item
    random_linked_taxon = random_taxon_page do |item|
      item["links"] = {}
    end

    random_taxon_page do |item|
      item["links"]["parent_taxons"] = [random_linked_taxon]
      item
    end
  end

  def education_content_item
    random_landing_page do |item|
      item.merge(education_content_item_fixture)
    end
  end

  def coronavirus_root_taxon_content_item
    GovukSchemas::Example.find("taxon", example_name: "taxon").tap do |item|
      item["base_path"] = "/coronavirus-taxon"
    end
  end

  def coronavirus_taxon_one
    GovukSchemas::Example.find("taxon", example_name: "taxon").tap do |item|
      item["links"]["parent_taxons"] = [coronavirus_root_taxon_content_item]
      item["links"]["ordered_related_items"] =
        [
          GovukSchemas::Example.find("guide", example_name: "guide"),
          GovukSchemas::Example.find("news_article", example_name: "news_article"),
        ]
    end
  end
end
