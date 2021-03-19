module DitLandingPageHelpers
  DIT_LANDING_PAGE_PATH = "/eubusiness".freeze

  def dit_landing_page_content_item(locale = nil)
    content_item = load_content_item("dit_landing_page.json")
    return content_item unless locale

    content_item["base_path"] = "#{DIT_LANDING_PAGE_PATH}.#{locale}"
    content_item["locale"] = locale
    content_item
  end

  def stub_dit_landing_page
    stub_content_store_has_item(DIT_LANDING_PAGE_PATH, dit_landing_page_content_item)
  end

  def stub_translated_dit_landing_pages
    %i[de es fr it nl pl].each do |locale|
      stub_content_store_has_item("#{DIT_LANDING_PAGE_PATH}.#{locale}", dit_landing_page_content_item(locale))
    end
  end

  def stub_all_eubusiness_pages
    stub_dit_landing_page
    stub_translated_dit_landing_pages
  end

  def load_content_item(file_name)
    json = File.read(
      Rails.root.join("test/fixtures/content_store/", file_name),
    )
    JSON.parse(json)
  end
end
