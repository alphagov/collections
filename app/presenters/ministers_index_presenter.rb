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

  def also_attends_cabinet
    @ministers_index.content_item.content_item_data.dig("links", "ordered_also_attends_cabinet").map do |minister_data|
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

    def roles
      current_role_appointments.map { |role_app|
        Role.new(
          title: role_app.dig("links", "role").first.fetch("title"),
          url: role_app.dig("links", "role").first["web_url"],
          seniority: role_app.dig("links", "role").first.fetch("details").fetch("seniority", 1000),
          payment_info: role_app.dig("links", "role").first.dig("details", "role_payment_type"),
        )
      }.sort_by(&:seniority)
    end

    def role_payment_info
      roles.map(&:payment_info).compact.uniq
    end

    Role = Struct.new(:title, :url, :seniority, :payment_info, keyword_init: true)

  private

    def current_role_appointments
      @data.dig("links", "role_appointments").select do |role_app|
        role_app.dig("details", "current") && role_app.dig("links", "role").first["web_url"].present?
      end
    end
  end
end
