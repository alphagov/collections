class SubtopicsController < ApplicationController
  def show

    taxon_resolver = TaxonRedirectResolver.new(
      request,
      is_page_in_ab_test: lambda {
        !redirects[params[:topic_slug]].nil? &&
          !redirects[params[:topic_slug]][params[:subtopic_slug]].nil?
      },
      map_to_taxon: lambda { redirects[params[:topic_slug]][params[:subtopic_slug]] }
    )

    if taxon_resolver.page_ab_tested?
      taxon_resolver.ab_variant.configure_response(response)
    end

    if taxon_resolver.taxon_base_path
      redirect_to controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path
    else
      subtopic = Topic.find(request.path)
      setup_content_item_and_navigation_helpers(subtopic)

      render :show, locals: {
        subtopic: subtopic,
        meta_section: subtopic.parent.title.downcase,
        ab_variant: taxon_resolver.ab_variant,
        is_page_under_ab_test: taxon_resolver.page_ab_tested?,
      }
    end
  end

private

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
