class CostOfLivingLandingPageController < ApplicationController
  slimmer_template "gem_layout_full_width"

  def show
    content = YAML.load_file(Rails.root.join("config/cost_of_living_landing_page/content_item.yml")).deep_symbolize_keys
    @content_item = content.to_h

    render "show", locals: {
      breadcrumbs:,
      content: CostOfLivingLandingPagePresenter.new(content),
    }
  end

  def contentful
    # this whacky line seems to be needed for breadcrumbs
    @content_item = content_item.to_hash

    render "contentful", locals: { breadcrumbs: }
  end

private

  def set_slimmer_template
    set_gem_layout_full_width
  end

  def breadcrumbs
    [{ title: t("shared.breadcrumbs_home"), url: "/", is_page_parent: true }]
  end
end
