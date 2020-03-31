class CoronavirusLandingPagePresenter
  COMPONENTS = %w(live_stream stay_at_home guidance announcements_label announcements nhs_banner sections topic_section country_section notifications).freeze

  def initialize(content_item)
    COMPONENTS.each do |component|
      define_singleton_method component do
        content_item["details"][component]
      end
    end
  end

  def show_live_stream?
    live_stream && live_stream["show_video"] == true
  end
end
