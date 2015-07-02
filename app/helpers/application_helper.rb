module ApplicationHelper
  def browsing_in_top_level_page?(top_level_page)
    request.path.starts_with?(top_level_page.base_path)
  end

  def browsing_in_second_level_page?(section)
    request.path.starts_with?(section.base_path)
  end

  def hairspace(string)
    string.gsub(/\s/, "\u200A") # \u200A = unicode hairspace
  end
end
