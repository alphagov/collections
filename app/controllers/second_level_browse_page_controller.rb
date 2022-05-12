class SecondLevelBrowsePageController < ApplicationController
  include RecruitmentBannerHelper
  enable_request_formats show: [:json]

  def show
    setup_content_item_and_navigation_helpers(page)
    @dimension26 = count_link_sections(page)
    @dimension27 = count_total_links(page)
    @study_url = study_url_for(request.path)

    respond_to do |f|
      f.html do
        show_html
      end
      f.json do
        render json: {
          content_id: page.content_id,
          navigation_page_type: "Second Level Browse",
          breadcrumbs: breadcrumb_content,
          html: render_partial("_links", page: page),
        }
      end
    end
  end

private

  def show_html
    template = :show

    if new_browse_variant_b?
      slimmer_template "gem_layout_full_width"
      template = if page.lists.curated?
                   :new_show_curated
                 else
                   :new_show_a_to_z
                 end
    end

    render(template, locals: { page: page, meta_section: meta_section })
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
