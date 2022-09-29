class CostOfLivingLandingPagePresenter
  COMPONENTS = %i[
    page_title
    metadata
    header
    body
  ].freeze

  def initialize(content_item)
    COMPONENTS.each do |component|
      define_singleton_method component do
        content_item[component]
      end
    end
  end

  def link_clicked_track_data(track_action:, href:)
    return { track_count: "contentLink" } unless internal_link?(href)

    {
      track_category: "contentsClicked",
      track_action: track_action,
      track_label: href,
      track_count: "contentLink",
    }
  end

private

  def internal_link?(link)
    link.starts_with?("/")
  end
end
