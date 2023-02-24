class PastPrimeMinister
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def page_title
    "History of #{title}"
  end

  def title
    @content_item.content_item_data["title"]
  end

  def political_party
    @content_item.content_item_data.dig("details", "political_party")
  end

  def dates_in_office
    @content_item.content_item_data.dig("details", "dates_in_office")
                 .map { |d| "#{d['start_year']} to #{d['end_year']}" }
                 .join(", ")
  end

  def description
    @content_item.content_item_data["description"]
  end

  def biography
    @content_item.content_item_data.dig("details", "body").html_safe
  end

  def image_data
    @content_item.content_item_data.dig("links", "person", 0, "details", "image")
  end

  def appointment_info_array
    %w[born died dates_in_office political_party major_acts interesting_facts].map do |field|
      text = field == "dates_in_office" ? dates_in_office : @content_item.content_item_data.dig("details", field)
      { title: field.gsub("_", " ").capitalize, text: }
    end
  end

  def related_prime_ministers_nav
    people = @content_item.content_item_data.dig("links", "ordered_related_items")
    {
      "links" => {
        "ordered_related_items" => people.map do |person|
          {
            "title" => person["title"],
            "base_path" => person["base_path"],
          }
        end,
      },
    }
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end
end
