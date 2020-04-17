CORONAVIRUS_TAXON_PATH = "/coronavirus-taxons".freeze

def coronavirus_landing_page_content_item
  load_content_item("coronavirus_landing_page.json")
end

def load_content_item(file_name)
  json = File.read(
    Rails.root.join("test/fixtures/content_store/", file_name),
  )
  JSON.parse(json)
end

def business_content_item_fixture
  load_content_item("business_support_page.json")
end

def random_landing_page
  GovukSchemas::RandomExample.for_schema(frontend_schema: "coronavirus_landing_page") do |item|
    yield(item)
  end
end

def coronavirus_content_item
  random_landing_page do |item|
    item.merge(coronavirus_landing_page_content_item)
  end
end

def coronavirus_content_item_with_no_time
  content_item = coronavirus_content_item
  content_item["details"]["live_stream"]["time"] = nil
  content_item
end

def business_content_item
  random_landing_page do |item|
    item.merge(business_content_item_fixture)
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
