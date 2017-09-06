class TopicsController < ApplicationController
  def index
    topic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(topic)

    render :index, locals: { topic: topic, is_page_under_ab_test: false }
  end

  def show
    taxon_resolver = TaxonRedirectResolver.new(
      ab_variant,
      is_page_in_ab_test: lambda { !redirects[params[:topic_slug]].nil? },
      map_to_taxon: lambda { redirects[params[:topic_slug]] }
    )

    if taxon_resolver.page_ab_tested?
      ab_variant.configure_response(response)
    end

    if taxon_resolver.taxon_base_path
      redirect_to(
        controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path,
        anchor: taxon_resolver.fragment
      )
    else
      topic = Topic.find(request.path)
      setup_content_item_and_navigation_helpers(topic)

      render :index, locals: {
        topic: topic,
        ab_variant: ab_variant,
        is_page_under_ab_test: taxon_resolver.page_ab_tested?,
      }
    end
  end

  def redirects
    Rails.application.config_for(:navigation_redirects)["topics"]
  end
end
