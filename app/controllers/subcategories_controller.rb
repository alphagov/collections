class SubcategoriesController < ApplicationController
  before_filter { validate_slug_param(:sector) }
  before_filter { validate_slug_param(:subcategory) }
  before_filter :set_beta_header
  before_filter :send_404_if_not_found
  before_filter :set_slimmer_format

  def show
    @groups = SpecialistSectorPresenter.build_from_subcategory_content(
      subcategory.groups,
      subcategory.parent_sector
    ).sort_by(&:title)

    set_slimmer_dummy_artefact(
      section_name: subcategory.parent_sector_title,
      section_link: "/#{params[:sector]}"
    )
  end

  def latest_changes
    set_slimmer_dummy_artefact(
      section_name: subcategory.title,
      section_link: subcategory_path(params.slice(:sector, :subcategory)),
      parent: {
        section_name: subcategory.parent_sector_title,
        section_link: "/#{params[:sector]}",
      }
    )

  end

private

  def subcategory
    @subcategory ||= Subcategory.find(slug)
  end
  helper_method :subcategory

  def organisations
    @organisations ||= sub_sector_organisations(slug)
  end
  helper_method :organisations

  def set_beta_header
    response.header[Slimmer::Headers::BETA_LABEL] = "after:.page-header"
  end

  def send_404_if_not_found
    error_404 unless subcategory.present?
  end

  def set_slimmer_format
    set_slimmer_headers(format: "specialist-sector")
  end

  def slug
    "#{params[:sector]}/#{params[:subcategory]}"
  end

  def sub_sector_organisations(slug)
    OrganisationsFacetPresenter.new(
      Collections::Application.config.search_client.unified_search(
        count: "0",
        filter_specialist_sectors: [slug],
        facet_organisations: "1000",
      )["facets"]["organisations"]
    )
  end
end
