class SubtopicsController < ApplicationController
  def show
    subtopic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(subtopic)

    render :show,
           locals: {
             subtopic:,
             meta_section: subtopic.parent.title.downcase,
           }
  end

private

  def organisations(subtopic_content_id)
    @organisations ||= subtopic_organisations(subtopic_content_id)
  end
  helper_method :organisations

  def subtopic_organisations(subtopic_content_id)
    params = {
      count: "0",
      filter_topic_content_ids: [subtopic_content_id],
      facet_organisations: "1000",
    }
    results = Services.cached_search(params)

    OrganisationsFacetPresenter.new(results["facets"]["organisations"])
  end
end
