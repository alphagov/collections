class LatestChangesController < SubtopicsController
  def index
    setup_content_item_and_navigation_helpers(subtopic)

    render :index,
           locals: {
             subtopic:,
             meta_section:,
             hardcoded_breadcrumbs:,
             pagination_presenter:,
           }
  end

private

  def pagination_presenter
    ChangedDocumentsPaginationPresenter.new(
      subtopic.changed_documents,
      view_context,
    )
  end

  def meta_section
    subtopic.parent.title.downcase
  end

  def subtopic_base_path
    request.path.sub(%r{/latest\z}, "")
  end

  def subtopic
    @subtopic ||= Topic.find(subtopic_base_path, pagination_params)
  end

  # Breadcrumbs for this page are hardcoded because it doesn't have a
  # content item with parents.
  def hardcoded_breadcrumbs
    [
      {
        title: t("shared.breadcrumbs_home"),
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
  end

  def pagination_params
    params_to_use = {}
    params_to_use[:start] = params[:start].to_i if params[:start].present?
    params_to_use[:count] = params[:count].to_i if params[:count].present?
    params_to_use
  end
end
