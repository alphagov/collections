module ApplicationHelper
  def out_of_date?
    false
  end

  def browsing_in_top_level_page?(top_level_page)
    request.path.starts_with?(top_level_page.base_path)
  end

  def browsing_in_second_level_page?(section)
    request.path == section.base_path
  end

  def current_path_without_query_string
    request.original_fullpath.split("?", 2).first
  end

  def is_testable_taxon_page?
    false
  end

  def page_text_direction
    @page_text_direction ||= I18n.t("shared.language_direction", default: "ltr")
  end

  def dir_attribute
    "dir=#{page_text_direction}" unless page_text_direction == "ltr"
  end

  def direction_rtl_class(prefix: false)
    if page_text_direction == "rtl"
      prefix ? "class=direction-rtl" : "direction-rtl"
    end
  end

  def lang_attribute
    "lang=#{I18n.locale}" unless I18n.locale == I18n.default_locale
  end

  def t_lang(key, options = {})
    fallback = t_fallback(key, options)
    if fallback && fallback != I18n.locale
      "lang=#{fallback}"
    end
  end

  def t_fallback(key, options = {})
    translation =
      begin
        I18n.t(key, options.merge(locale: I18n.locale, fallback: false, default: "fallback"))
      rescue I18n::InvalidPluralizationData
        nil
      end

    if !translation || translation.eql?("fallback")
      I18n.default_locale
    elsif translation.is_a? Hash
      translation.values.all?(&:nil?) ? I18n.default_locale : false
    else
      false
    end
  end

  def render_govspeak(content, inverse: false)
    render "govuk_publishing_components/components/govspeak", inverse: inverse do
      raw(Govspeak::Document.new(content, sanitize: false).to_html)
    end
  end
end
