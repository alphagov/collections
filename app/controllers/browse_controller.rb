class BrowseController < ApplicationController
  rescue_from GdsApi::HTTPNotFound, with: lambda {
    statsd.increment("browse.not_found")
    error_404
  }

  before_filter(:only => [:section, :sub_section]) { validate_slug_param(:section) }
  before_filter(:only => [:sub_section]) { validate_slug_param(:sub_section) }

  def index
    options = {title: "browse", section_name: "Browse", section_link: "/browse"}
    set_slimmer_artefact_headers(options)
  end

  def section
    return error_404 unless section_tag

    set_slimmer_artefact_headers
  end

  def sub_section
    return error_404 unless sub_section_tag

    options = {title: "browse", section_name: section_tag.title, section_link: section_tag.web_url}
    set_slimmer_artefact_headers(options)
  end

private

  def section_slug
    params[:section]
  end

  def sub_section_slug
    [section_slug, params[:sub_section]].join('/')
  end

  def section_tag
    @section ||= content_api.tag(section_slug)
  end
  helper_method :section_tag

  def section_tags
    @section_tags ||= content_api.sub_sections(section_slug).results.sort_by { |category| category.title }
  end
  helper_method :section_tags

  def sub_section_tag
    @sub_section ||= content_api.tag(sub_section_slug)
  end
  helper_method :sub_section_tag

  def sub_section_artefacts
    @sub_section_artefacts ||= content_api.with_tag(sub_section_slug).results.sort_by { |category| category.title }
  end
  helper_method :sub_section_artefacts

  def root_sections
    @root_sections ||= content_api.root_sections.results.sort_by { |category| category.title }
  end
  helper_method :root_sections

  def detailed_guide_categories
    @detailed_categories ||= detailed_guidance_content_api.sub_sections(sub_section_slug).results.sort_by { |category| category.title }
  rescue GdsApi::HTTPNotFound, GdsApi::HTTPGone
    @detailed_categories ||= []
  end
  helper_method :detailed_guide_categories

  def validate_slug_param(param_name = :slug)
    if params[param_name].parameterize != params[param_name]
      cacheable_404
    end
  end

  def set_slimmer_artefact_headers(dummy_artefact={})
    set_slimmer_headers(format: 'browse')
    set_slimmer_dummy_artefact(dummy_artefact) unless dummy_artefact.empty?
  end
end
