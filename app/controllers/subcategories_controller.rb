class SubcategoriesController < ApplicationController
  before_filter(:only => [:show]) { validate_slug_param(:sector) }
  before_filter(:only => [:show]) { validate_slug_param(:subcategory) }
  before_filter :set_beta_header

  TAG_TYPE = "specialist_sector"

  def show
    @subcategory = content_api.tag(tag_id, TAG_TYPE)
    return error_404 unless @subcategory.present?

    @sector = @subcategory.parent
    @results = content_api.with_tag(tag_id, TAG_TYPE).map { |artefact| SpecialistSectorPresenter.new(artefact, @sector) }
    @results.sort_by!(&:title)

    @organisations = sub_sector_organisations(tag_id)

    set_slimmer_dummy_artefact(section_name: @sector.title, section_link: "/#{params[:sector]}")
    set_slimmer_headers(format: "specialist-sector")
  end

private

  def set_beta_header
    response.header[Slimmer::Headers::BETA_LABEL] = "after:.page-header"
  end

  def tag_id
    "#{params[:sector]}/#{params[:subcategory]}"
  end

  def sub_sector_organisations(tag_id)
    OrganisationsFacetPresenter.new(
      Collections::Application.config.search_client.unified_search(
        count: "0",
        filter_specialist_sectors: [tag_id],
        facet_organisations: "1000",
      )["facets"]["organisations"]
    )
  end
end
