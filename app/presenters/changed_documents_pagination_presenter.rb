class ChangedDocumentsPaginationPresenter
  def initialize(changed_documents, view_context)
    @changed_documents = changed_documents
    @view_context = view_context
  end

  def previous_and_next_navigation
    component_params = {}

    if previous_page?
      component_params[:previous_page] = {
        url: previous_page_path,
        title: I18n.t("latest_changes.previous"),
        label: "#{previous_page_number} of #{total_pages}",
      }
    end

    if next_page?
      component_params[:next_page] = {
        url: next_page_path,
        title: I18n.t("latest_changes.next"),
        label: "#{next_page_number} of #{total_pages}",
      }
    end

    component_params
  end

  def total_pages
    (@changed_documents.total.to_f / @changed_documents.page_size).ceil
  end

  def current_page_number
    # Add 1 because page numbers are 1-indexed
    (@changed_documents.start.to_f / @changed_documents.page_size).ceil + 1
  end

  def next_page?
    current_page_number < total_pages
  end

  def previous_page?
    current_page_number > 1
  end

  def next_page_number
    current_page_number + 1
  end

  def previous_page_number
    current_page_number - 1
  end

  def next_page_path
    @view_context.latest_changes_path(pagination_params(next_page_number))
  end

  def previous_page_path
    @view_context.latest_changes_path(pagination_params(previous_page_number))
  end

private

  def pagination_params(page_number)
    params = {}
    if page_number > 1
      params[:start] = (page_number - 1) * @changed_documents.page_size
    end
    if custom_page_size?
      params[:count] = @changed_documents.page_size
    end
    params
  end

  def custom_page_size?
    @changed_documents.page_size != Topic::ChangedDocuments::DEFAULT_PAGE_SIZE
  end
end
