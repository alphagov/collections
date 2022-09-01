class CostOfLivingLandingPageController < ApplicationController
  slimmer_template "gem_layout_full_width"

  def show
    render "show", locals: {
      breadcrumbs: breadcrumbs,
      content: presenter,
    }
  end

private

  def set_slimmer_template
    set_gem_layout_full_width
  end

  def content_item
    @content_item ||= YAML.load_file(Rails.root.join("config/cost_of_living_landing_page/content_item.yml")).deep_symbolize_keys
  end

  def presenter
    @presenter ||= CostOfLivingLandingPagePresenter.new(content_item)
  end

  def breadcrumbs
    [{ title: t("shared.breadcrumbs_home"), url: "/", is_page_parent: true }]
  end
end
