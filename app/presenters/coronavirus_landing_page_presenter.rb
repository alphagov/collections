class CoronavirusLandingPagePresenter
  COMPONENTS = %w(live_stream stay_at_home guidance announcements_label announcements nhs_banner sections topic_section country_section notifications).freeze

  def initialize(content_item)
    COMPONENTS.each do |component|
      define_singleton_method component do
        content_item["details"][component]
      end
    end
  end

  def parsed_stream_date
    if live_stream_date.present?
      ints = live_stream_date.split("/").map(&:to_i)
      begin
        DateTime.new(ints[2], ints[1], ints[0]).strftime("%d %B %Y").sub(/^0/, "")
      rescue ArgumentError
        ""
      end
    else
      ""
    end
  end

  def parsed_stream_time
    if live_stream_time.present?
      begin
        DateTime.parse(live_stream_time).strftime("%I:%M %P").sub(/^0/, "")
      rescue ArgumentError
        ""
      end
    else
      ""
    end
  end

private

  def live_stream_date
    live_stream["date"]
  end

  def live_stream_time
    live_stream["time"]
  end
end
