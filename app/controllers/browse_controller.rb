class BrowseController < ApplicationController
  rescue_from GdsApi::HTTPNotFound, with: :error_404

  before_filter(:only => [:top_level_browse_page, :second_level_browse_page]) { validate_slug_param(:top_level_slug) }
  before_filter(:only => [:second_level_browse_page]) { validate_slug_param(:second_level_slug) }

  enable_request_formats top_level_browse_page: [:json]
  enable_request_formats second_level_browse_page: [:json]

  def index
    @page = IndexBrowsePage.new
    set_slimmer_artefact_headers(@page.slimmer_breadcrumb_options)
  end

  def top_level_browse_page
    @page = TopLevelBrowsePage.new(params[:top_level_slug])
    set_slimmer_artefact_headers(@page.slimmer_breadcrumb_options)

    respond_to do |f|
      f.html
      f.json do
        render json: { html: second_level_browse_pages_partial(@page) }
      end
    end
  end

  def second_level_browse_page
    @page = SecondLevelBrowsePage.new(params[:top_level_slug], params[:second_level_slug])
    set_slimmer_artefact_headers(@page.slimmer_breadcrumb_options)

    respond_to do |f|
      f.html
      f.json do
        render json: { html: render_partial('_links') }
      end
    end
  end

private

  def second_level_browse_pages_partial(page)
    render_partial('_second_level_browse_pages',
        title: page.title,
        second_level_browse_pages: page.second_level_browse_pages)
  end

  def set_slimmer_artefact_headers(dummy_artefact={})
    set_slimmer_headers(format: 'browse')
    set_slimmer_dummy_artefact(dummy_artefact) unless dummy_artefact.empty?
  end

  def render_partial(partial_name, locals = {})
    render_to_string(partial_name, formats: 'html', layout: false, locals: locals)
  end
end
