class StepNav
  attr_reader :content_item

  delegate(
    :content_id,
    :base_path,
    :title,
    :description,
    :details,
    :to_hash,
    to: :content_item,
  )

  def initialize(content_item)
    @content_item = content_item
  end

  def introduction
    details["step_by_step_nav"]["introduction"].html_safe
  end

  def payload_for_component
    details["step_by_step_nav"].deep_symbolize_keys.merge(remember_last_step: true, tracking_id: content_id)
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def structured_data(image_urls)
    step_items = details["step_by_step_nav"]["steps"].map.with_index(1) do |step, step_index|
      contents = step["contents"].map.with_index(1) do |content, item_index|
        direction_index = item_index

        if content["type"] == "paragraph"
          how_to_direction(content, direction_index)
        elsif content["type"] == "list"
          content["contents"].map do |c|
            how_to_direction(c, direction_index).tap do
              direction_index += 1
            end
          end
        end
      end

      {
        "@type": "HowToStep",
        "image": image_urls,
        "name": step["title"],
        "url": step_url(step["title"].parameterize),
        "position": step_index,
        "itemListElement": contents.flatten.compact,
      }
    end

    {
      "@context": "http://schema.org",
      "@type": "HowTo",
      "description": description,
      "image": image_urls,
      "name": title,
      "step": step_items,
    }
  end

  def how_to_direction(content, index)
    {
      "@type": "HowToDirection",
      "text": content["text"],
      "position": index,
    }.merge(direction_url(content))
  end

  def direction_url(content)
    if content["href"]
      { "url": url_for_base_path_or_absolute_url(content["href"]) }
    else
      {}
    end
  end

  def url_for_base_path_or_absolute_url(href)
    if href.starts_with?("http")
      href
    else
      Plek.new.website_root + href
    end
  end

  def step_url(step_slug)
    Plek.new.website_root + base_path + "#" + step_slug
  end
end
