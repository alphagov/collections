class BrowseController < ApplicationController
  rescue_from GdsApi::HTTPNotFound, with: lambda {
    statsd.increment("browse.not_found")
    error_404
  }

  before_filter(:only => [:section, :sub_section]) { validate_slug_param(:section) }
  before_filter(:only => [:sub_section]) { validate_slug_param(:sub_section) }

  enable_request_formats section: [:json]
  enable_request_formats sub_section: [:json]

  def index
    options = {title: "browse", section_name: "Browse", section_link: "/browse"}
    set_slimmer_artefact_headers(options)
  end

  def section
    return error_404 unless section_tag

    set_slimmer_artefact_headers

    respond_to do |f|
      f.html
      f.json do
        render json: { html: render_partial('_section') }
      end
    end
  end

  def sub_section
    return error_404 unless sub_section_tag

    @related_topics = RelatedTopicList.new(
      Collections.services(:content_store),
      Collections.services(:detailed_guidance_content_api)
    ).related_topics_for(request.path.gsub('.json', ''))

    options = {title: "browse", section_name: section_tag.title, section_link: section_tag.web_url}
    set_slimmer_artefact_headers(options)

    respond_to do |f|
      f.html
      f.json do
        render json: { html: render_partial('_subsection') }
      end
    end
  end

private

  def section_slug
    params[:section]
  end

  def sub_section_slug
    [section_slug, params[:sub_section]].join('/')
  end

  def section_tag
    @section ||= Collections.services(:content_api).tag(section_slug)
  end
  helper_method :section_tag

  def section_tags
    @section_tags ||= Collections.services(:content_api).sub_sections(section_slug).results.sort_by { |category| category.title }
  end
  helper_method :section_tags

  def sub_section_tag
    @sub_section ||= Collections.services(:content_api).tag(sub_section_slug)
  end
  helper_method :sub_section_tag

  def sub_section_artefacts
    @sub_section_artefacts ||= Collections.services(:content_api).with_tag(sub_section_slug).results.sort_by { |category| category.title }
  end
  helper_method :sub_section_artefacts

  def root_sections
    @root_sections ||= Collections.services(:content_api).root_sections.results.sort_by { |category| category.title }
  end
  helper_method :root_sections

  def set_slimmer_artefact_headers(dummy_artefact={})
    set_slimmer_headers(format: 'browse')
    set_slimmer_dummy_artefact(dummy_artefact) unless dummy_artefact.empty?
  end

  def render_partial(partial_name)
    render_to_string(partial_name, formats: 'html', layout: false)
  end
end
