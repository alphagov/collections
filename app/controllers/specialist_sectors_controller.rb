class SpecialistSectorsController < ApplicationController
  before_filter { validate_slug_param(:sector) }
  before_filter :set_beta_header

  def show
    @sector = SpecialistSector.new(content_api, sector_tag).build

    return error_404 unless @sector.present?

    set_slimmer_headers(format: "specialist-sector")
  end

private

  def set_beta_header
    response.header[Slimmer::Headers::BETA_LABEL] = "after:.page-header"
  end

  def sector_tag
    params[:sector]
  end
end
