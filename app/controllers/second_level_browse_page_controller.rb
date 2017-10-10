class SecondLevelBrowsePageController < ApplicationController
  include TaskListAbTestingConcern

  enable_request_formats show: [:json]

  def show
    setup_content_item_and_navigation_helpers(page)

    respond_to do |f|
      f.html do
        show_html
      end
      f.json do
        render json: {
          breadcrumbs: breadcrumb_content,
          html: render_partial('_links', page: page, task_list_ab_test: task_list_ab_test)
        }
      end
    end
  end

private

  def show_html
    render :show, locals: {
      page: page,
      meta_section: meta_section,
      task_list_ab_test: task_list_ab_test,
      task_list_ab_variant: task_list_ab_variant,
      page_is_under_task_list_ab_test: page_is_under_task_list_ab_test?
    }
  end

  def meta_section
    page.active_top_level_browse_page.title.downcase
  end

  def page_is_under_task_list_ab_test?
    params[:top_level_slug] == 'driving' &&
      params[:second_level_slug] == 'learning-to-drive'
  end

  def page
    MainstreamBrowsePage.find(
      "/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}"
    )
  end
end
