class SpecialistSectorsController < ApplicationController
  before_filter { validate_slug_param(:sector) }

  def show
    @sector = SpecialistSector.new(content_api, sector_tag).build

    return error_404 unless @sector.present?

    set_slimmer_headers(format: "specialist-sector")
  end

private

  def content_api
    Collections.services(:content_api)
  end

  def sector_tag
    params[:sector]
  end
end
