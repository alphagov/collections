class DitLandingPageController < ApplicationController
  around_action :switch_locale

  def show; end

  helper_method :translation_links

  def translation_links
    available_translations.map do |translation|
      {
        locale: translation,
        base_path: path(translation),
        text: language_name(translation),
        active: locale == translation,
      }
    end
  end

  def path(language)
    raw_path = request.path.split(".")[0]
    language == :en ? raw_path : "#{raw_path}.#{language}"
  end

  def language_name(language)
    I18n.t("shared.language_names.#{language}")
  end

  def available_translations
    %i[en de es fr it nl pl]
  end
end
