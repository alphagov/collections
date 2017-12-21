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

  def current_path_without_query_string
    request.original_fullpath.split("?", 2).first
  end

  def tasklist_link_for(title, path, section_index)
    link_to(
      title,
      path,
      data: {
        track_category: 'thirdLevelBrowseLinkClicked',
        track_action: "#{section_index + 1}.0",
        track_label: path,
        track_options: {
          dimension29: title
        }
      }
    )
  end
end
