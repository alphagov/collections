class SpecialistSectorsController < ApplicationController

  TAG_TYPE = "specialist_sector"

  before_filter(:only => [:show]) { validate_slug_param(:sector) }
  before_filter :set_beta_header

  def show
    @sector = content_api.tag(params[:sector], TAG_TYPE)
    return error_404 unless @sector.present?

    @child_tags = content_api.child_tags(TAG_TYPE, params[:sector], sort: 'alphabetical')

    set_slimmer_headers(format: "specialist-sector")
  end

private

  def set_beta_header
    response.header[Slimmer::Headers::BETA_LABEL] = "after:.page-header"
  end
end
