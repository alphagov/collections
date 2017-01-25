class LatestChangesController < SubtopicsController
  def index
    setup_content_item_and_navigation_helpers(subtopic)

    render :index, locals: {
      subtopic: subtopic,
      meta_section: meta_section,
      hardcoded_breadcrumbs: hardcoded_breadcrumbs,
      pagination_presenter: pagination_presenter
    }
  end

private

  def pagination_presenter
    ChangedDocumentsPaginationPresenter.new(
      subtopic.changed_documents,
      view_context
    )
  end

  def meta_section
    subtopic.parent.title.downcase
  end

  def subtopic_base_path
    request.path.sub(%r{/latest\z}, '')
  end

  def subtopic
    Topic.find(subtopic_base_path, pagination_params)
  end

  # Breadcrumbs for this page are hardcoded because it doesn't have a
  # content item with parents.
  def hardcoded_breadcrumbs
    {
      breadcrumbs: [
        {
          title: "Home",
          url: "/",
        },
        {
          title: subtopic.parent.title,
          url: subtopic.parent.base_path,
        },
        {
          title: subtopic.title,
          url: subtopic.base_path,
        },
      ]
    }
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
