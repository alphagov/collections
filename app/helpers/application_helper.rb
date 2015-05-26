module ApplicationHelper
  def browsing_in_root_section?(root_section)
    params[:section].present? && params[:section] == root_section.slug
  end

  def browsing_in_section?(section)
    params[:sub_section].present? && full_slug == section.slug
  end

private

  def full_slug
    [params[:section], params[:sub_section]].join('/')
  end
end
