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

  def is_testable_taxon_page?
    false
  end

  def t_lang(key, options = {})
    fallback = t_fallback(key, options)
    if fallback && fallback != I18n.locale
      "lang=#{fallback}"
    end
  end

  def t_fallback(key, options = {})
    translation = I18n.t(key, options, locale: I18n.locale, fallback: false, default: "fallback")

    if !translation || translation.eql?("fallback")
      I18n.default_locale
    elsif translation.is_a? Hash
      translation.values.all?(&:nil?) ? I18n.default_locale : false
    else
      false
    end
  end
end
