class OrganisationsNo10PagePresenter
  COMPONENTS = %i[
    header
  ].freeze

  def no_10_page_content
    YAML.load_file(Rails.root.join("config/organisations_no_10_page/content_item.yml")).deep_symbolize_keys
  end

  def initialize
    COMPONENTS.each do |component|
      define_singleton_method component do
        no_10_page_content[component]
      end
    end
  end
end
