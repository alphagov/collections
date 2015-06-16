module ApplicationHelper
  def browsing_in_top_level_page?(top_level_page)
    params[:top_level_slug].present? && params[:top_level_slug] == top_level_page.slug
  end

  def browsing_in_second_level_page?(section)
    params[:second_level_slug].present? && full_slug == section.slug
  end

private

  def full_slug
    [params[:top_level_slug], params[:second_level_slug]].join('/')
  end
end
