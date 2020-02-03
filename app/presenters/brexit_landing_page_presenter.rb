require "yaml"
require "govspeak"

class BrexitLandingPagePresenter
  attr_reader :taxon, :buckets
  delegate(
    :title,
    :base_path,
    to: :taxon,
  )

  def initialize(taxon)
    @taxon = taxon
    @buckets = fetch_buckets
  end

  def supergroup_sections
    brexit_sections = SupergroupSections::BrexitSections.new(taxon.content_id,
                                                             taxon.base_path)
                                                        .sections
    brexit_sections.map do |section|
      supergroup_title = I18n.t(section[:name], scope: %i[brexit_landing_page sections])
      {
        text: supergroup_title,
        path: section[:see_more_link][:url],
        data_attributes: section[:see_more_link][:data],
        aria_label: supergroup_title + " related to the transition period",
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
        text: I18n.t("shared.language_names.#{link.locale}"),
        active: active,
      }
    end

    links.sort_by { |t| t[:locale] == I18n.default_locale.to_s ? "" : t[:locale] }
  end

private

  SWITCHOVER_TIME = Time.zone.parse("2020-01-31 23:00:00").in_time_zone

  def time_based_intl
    if before_switchover?
      "brexit_landing_page"
    else
      "transition_landing_page"
    end
  end

  def before_switchover?
    Time.zone.now < SWITCHOVER_TIME
  end

  def fetch_buckets
    buckets = I18n.t("transition_landing_page.campaign_buckets")
    buckets.each do |bucket|
      bucket[:list_block] = convert_to_govspeak(bucket[:list_block])
    end
  end

  def convert_to_govspeak(markdown)
    Govspeak::Document.new(markdown).to_html.html_safe unless markdown.nil?
  end
end
