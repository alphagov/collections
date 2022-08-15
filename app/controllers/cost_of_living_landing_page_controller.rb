class CostOfLivingLandingPageController < ApplicationController
  slimmer_template "gem_layout_full_width"

  rescue_from GdsApi::ContentStore::ItemNotFound, with: :show

  def show
    @content_item = { "locale" => "en" }

    render "show", locals: {
      breadcrumbs: breadcrumbs,
      content: content,
    }
  end

private

  def set_slimmer_template
    set_gem_layout_full_width
  end

  def content
    @content ||= YAML.load_file(Rails.root.join("config/cost_of_living_landing_page/content_item.yml")).symbolize_keys
  end

  def breadcrumbs
    [{ title: t("shared.breadcrumbs_home"), url: "/", is_page_parent: true }]
  end
end
