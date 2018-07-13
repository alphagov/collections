class StepNav
  attr_reader :content_item

  delegate(
    :content_id,
    :base_path,
    :title,
    :description,
    :details,
    :to_hash,
    to: :content_item
  )

  def initialize(content_item)
    @content_item = content_item
  end

  def introduction
    details["step_by_step_nav"]["introduction"]
  end

  def payload_for_component
    details["step_by_step_nav"].deep_symbolize_keys.merge(remember_last_step: true, tracking_id: content_id)
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def structured_data
    step_items = details["step_by_step_nav"]["steps"].map do |step|
      contents = step["contents"].map do |content|
        if content["type"] == "paragraph"
          content["text"]
        elsif content["type"] == "list"
          content["contents"].map do |c|
            next unless c["href"]

            {
              "@type": "WebPage",
              "@id": url_for_base_path_or_absolute_url(c["href"]),
              "name": c["text"],
            }
          end
        end
      end

      {
        "@type": "HowToStep",
        "name": step["title"],
        "itemListElement": contents.flatten.compact,
      }
    end

    {
      "@context": "http://schema.org",
      "@type": "HowTo",
      "name": title,
      "steps": {
        "@type": "ItemList",
        "itemListElement": step_items,
      }
    }
  end

  def url_for_base_path_or_absolute_url(href)
    if href.starts_with?("http")
      href
    else
      Plek.new.website_root + href
    end
  end
end
