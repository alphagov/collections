class SubcategoriesController < ApplicationController
  before_filter { validate_slug_param(:sector) }
  before_filter { validate_slug_param(:subcategory) }
  before_filter :set_beta_header

  def show
    @subcategory = Subcategory.new(content_api, tag_id).build

    return error_404 unless @subcategory.present?

    @results = SpecialistSectorPresenter.build_from_subcategory_content(
      @subcategory.related_content,
      @subcategory.parent
    )

    @results.sort_by!(&:title)

    @organisations = sub_sector_organisations(tag_id)

    set_slimmer_dummy_artefact(
      section_name: @subcategory.parent_sector_title,
      section_link: "/#{params[:sector]}",
    )
    set_slimmer_headers(format: "specialist-sector")
  end

private

  def content_api
    Collections.services(:content_api)
  end

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
