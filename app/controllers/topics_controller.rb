class TopicsController < ApplicationController
  def index
    @topic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(@topic)
  end

  def show
    @topic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(@topic)
  end

  def latest_changes
    subtopic_base_path = request.path.sub(%r{/latest\z}, '')
    @subtopic = Topic.find(subtopic_base_path, pagination_params)
    @meta_section = @subtopic.parent.title.downcase
    # Breadcrumbs for this page are hardcoded because it doesn't have a
    # content item with parents.
    @hardcoded_breadcrumbs = {
      breadcrumbs: [
        {
          title: "Home",
          url: "/",
        },
        {
          title: @subtopic.parent.title,
          url: @subtopic.parent.base_path,
        },
        {
          title: @subtopic.title,
          url: @subtopic.base_path,
        },
      ]
    }
    @pagination_presenter = ChangedDocumentsPaginationPresenter.new(@subtopic.changed_documents, view_context)
    setup_content_item_and_navigation_helpers(@subtopic)
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
