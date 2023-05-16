class MinistersIndexPresenter
  def initialize(ministers_index)
    @ministers_index = ministers_index
  end

  def lead_paragraph
    @ministers_index.content_item.details.fetch("body", nil)
  end

  def is_during_reshuffle?
    @ministers_index.content_item.details.fetch("reshuffle", nil)
  end

  def reshuffle_messaging
    @ministers_index.content_item.details.dig("reshuffle", "message")
  end

  def cabinet_ministers
    @ministers_index.content_item.content_item_data.dig("links", "ordered_cabinet_ministers").map do |minister_data|
      Minister.new(minister_data)
    end
  end

  class Minister
    def initialize(data)
      @data = data
    end

    def person_url
      @data["web_url"]
    end

    def name
      @data.fetch("title").gsub("The Rt Hon", "").strip
    end

    def honorific
      @data.dig("details", "privy_counsellor") ? "The Rt Hon" : ""
    end

    def image_url
      @data.dig("details", "image", "url")
    end

    def image_alt
      @data.dig("details", "image", "alt_text")
    end
  end
end
