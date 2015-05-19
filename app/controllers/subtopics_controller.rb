class SubtopicsController < ApplicationController
  before_filter { validate_slug_param(:sector) }
  before_filter { validate_slug_param(:subcategory) }
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
    @subcategory ||= Subcategory.find(slug, pagination_params)
  end
  helper_method :subcategory

  def organisations
    @organisations ||= sub_sector_organisations(slug)
  end
  helper_method :organisations

  def changed_documents_pagination
    @changed_documents_pagination ||= ChangedDocumentsPaginationPresenter.new(
      subcategory,
      per_page: pagination_params[:count]
    )
  end
  helper_method :changed_documents_pagination

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

  def pagination_params
    params_to_use = params.slice(:start, :count).symbolize_keys

    # primitive sanitisation of the pagination parameters to ensure they're
    # integers
    params_to_use.inject({}) {|hash, (key, value)|
      hash[key] = value.to_i if value.present?
      hash
    }
  end
end
