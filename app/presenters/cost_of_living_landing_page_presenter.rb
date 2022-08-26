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
end
