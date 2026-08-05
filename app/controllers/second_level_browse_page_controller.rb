class SecondLevelBrowsePageController < ApplicationController
  def show
    @full_width = true
    setup_content_item_and_navigation_helpers(page)
    show_html
  end

private

  def show_html
    template = if page.lists.curated?
                 :show_curated
               else
                 :show_a_to_z
               end
    render(template, locals: { page:, curated_partial: "show_curated_list", meta_section: })
  end

  def meta_section
    page.active_top_level_browse_page.title.downcase
  end

  def page
    @page ||= MainstreamBrowsePage.find(
      "/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}",
    )
  end
end
