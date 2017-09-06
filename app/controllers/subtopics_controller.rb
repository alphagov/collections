class SubtopicsController < ApplicationController
  before_action :configure_ab_response, if: :page_in_ab_test?

  def show
    taxon_resolver = TaxonRedirectResolver.new(
      ab_variant,
      page_is_in_ab_test: page_in_ab_test?,
      map_to_taxon: second_level_redirect
    )

    if taxon_resolver.taxon_base_path
      redirect_to(
        controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path,
        anchor: taxon_resolver.fragment
      )
    else
      subtopic = Topic.find(request.path)
      setup_content_item_and_navigation_helpers(subtopic)

      render :show, locals: {
        subtopic: subtopic,
        meta_section: subtopic.parent.title.downcase,
        ab_variant: ab_variant,
        is_page_under_ab_test: page_in_ab_test?,
      }
    end
  end

private

  def page_in_ab_test?
    top_level_redirect.present? && second_level_redirect.present?
  end

  def top_level_redirect
    redirects[params[:topic_slug]]
  end

  def second_level_redirect
    redirects.dig(params[:topic_slug], params[:subtopic_slug])
  end

  def organisations(subtopic_content_id)
    @organisations ||= subtopic_organisations(subtopic_content_id)
  end
  helper_method :organisations

  def subtopic_organisations(subtopic_content_id)
    OrganisationsFacetPresenter.new(
      Services.rummager.search(
        count: "0",
        filter_topic_content_ids: [subtopic_content_id],
        facet_organisations: "1000",
      )["facets"]["organisations"]
    )
  end

  def redirects
    Rails.application.config_for(:navigation_redirects)["subtopics"]
  end
end
