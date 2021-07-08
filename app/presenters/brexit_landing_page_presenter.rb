require "yaml"
require "govspeak"

class BrexitLandingPagePresenter
  attr_reader :taxon

  delegate(
    :title,
    :base_path,
    to: :taxon,
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def supergroup_sections
    brexit_sections = SupergroupSections::BrexitSections.new(
      taxon.content_id,
      taxon.base_path,
    )
                                                        .sections
    brexit_sections.map do |section|
      supergroup_title = I18n.t(section[:name], scope: %i[brexit_landing_page sections])
      {
        text: supergroup_title,
        path: section[:see_more_link][:url],
        data_attributes: {
          track_category: "brexit-landing-page",
          track_action: supergroup_title,
          track_label: "All Brexit information",
          module: "gem-track-click",
        },
        aria_label: "#{supergroup_title} #{I18n.t('brexit_landing_page.sections.aria_string_suffix')}",
      }
    end
  end

  def email_path
    base_path.split(".").first
  end

  def translation_links
    links = taxon.translations.map do |link|
      active = true if link.base_path == taxon.base_path

      {
        locale: link.locale,
        base_path: link.base_path,
        text: I18n.t("shared.language_name", locale: link.locale),
        active: active,
      }
    end

    links.sort_by { |t| t[:locale] == I18n.default_locale.to_s ? "" : t[:locale] }
  end

private

  def convert_to_govspeak(markdown)
    Govspeak::Document.new(markdown).to_html.html_safe unless markdown.nil?
  end
end
