class SecondLevelBrowsePageController < ApplicationController
  def show
    setup_content_item_and_navigation_helpers(page)
    @dimension26 = count_link_sections(page)
    @dimension27 = count_total_links(page)
    show_html
  end

private

  def show_html
    slimmer_template "gem_layout_full_width"

    template = if page.lists.curated?
                 :show_curated
               else
                 :show_a_to_z
               end
    render(template, locals: { page: page, curated_partial: "show_curated_list", meta_section: meta_section })
  end

  def meta_section
    page.active_top_level_browse_page.title.downcase
  end

  def page
    @page ||= MainstreamBrowsePage.find(
      "/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}",
    )
  end

  def count_link_sections(page)
    page.lists.count + page.related_topics.count
  end

  def count_total_links(page)
    link_count = 0
    page.lists.each do |list|
      link_count += list.contents.count
    end

    if page.related_topics.any?
      link_count += page.related_topics.count
    end

    link_count
  end
end
