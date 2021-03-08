class DitLandingPagePresenter
  def initialize(content_item)
    @content_item = content_item
  end

  def translation_links
    translations = available_translations.map do |item|
      {
        locale: item.locale,
        base_path: item.base_path,
        text: I18n.t("shared.language_name", locale: item.locale),
        active: (item.base_path == content_item.base_path),
      }
    end
    sort_by_default_locale(translations)
  end

private

  attr_reader :content_item

  def available_translations
    content_item.linked_items("available_translations")
  end

  def sort_by_default_locale(translations)
    translations.sort_by { |t| t[:locale] == I18n.default_locale.to_s ? "" : t[:locale] }
  end
end
