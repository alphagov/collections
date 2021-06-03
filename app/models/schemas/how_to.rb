class Schemas::HowTo
  delegate(
    :base_path,
    :title,
    :description,
    :details,
    to: :step_by_step,
  )

  def initialize(step_by_step, view_context)
    @step_by_step = step_by_step
    @view_context = view_context
    @step_image_index = 1
  end

  def structured_data
    step_items = details["step_by_step_nav"]["steps"].map.with_index(1) do |step, step_index|
      contents = step["contents"].map.with_index(1) do |content, item_index|
        direction_index = item_index

        case content["type"]
        when "paragraph"
          how_to_direction(content, direction_index)
        when "list"
          content["contents"].map do |c|
            how_to_direction(c, direction_index).tap do
              direction_index += 1
            end
          end
        end
      end

      {
        "@type": "HowToStep",
        "image": step_image_url(step),
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
      "image": image_urls["placeholder"],
      "name": title,
      "step": step_items,
    }
  end

private

  attr_reader :step_by_step, :step_image_index, :view_context

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
    "#{Plek.new.website_root}#{base_path}##{step_slug}"
  end

  def step_image_url(step)
    if step["logic"] == "and"
      image_urls["and"]
    elsif step["logic"] == "or"
      image_urls["or"]
    elsif step_image_index <= 12
      image_urls[@step_image_index.to_s].tap do
        @step_image_index += 1
      end
    end || image_urls["placeholder"]
  end

  def image_urls
    @image_urls ||= begin
      (1..12).each_with_object({}) { |index, image_urls|
        image_urls[index.to_s] = view_context.image_url("step-#{index}.png")
      }.merge(
        "or" => view_context.image_url("step-or.png"),
        "and" => view_context.image_url("step-and.png"),
        "placeholder" => view_context.image_url("govuk_publishing_components/govuk-schema-placeholder-1x1.png"),
      )
    end
  end
end
