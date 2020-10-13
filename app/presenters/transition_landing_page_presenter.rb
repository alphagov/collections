require "yaml"
require "govspeak"

class TransitionLandingPagePresenter
  attr_reader :taxon, :comms, :buckets
  delegate(
    :title,
    :base_path,
    to: :taxon,
  )

  def initialize(taxon)
    @taxon = taxon
    @comms = fetch_comms
    @buckets = fetch_buckets
  end

  def supergroup_sections
    brexit_sections = SupergroupSections::BrexitSections.new(
      taxon.content_id,
      taxon.base_path,
    )
                                                        .sections
    brexit_sections.map do |section|
      supergroup_title = I18n.t(section[:name], scope: %i[transition_landing_page sections])
      {
        text: supergroup_title,
        path: section[:see_more_link][:url],
        data_attributes: section[:see_more_link][:data],
        aria_label: "#{supergroup_title} #{I18n.t('transition_landing_page.sections.aria_string_suffix')}",
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

  def fetch_buckets
    buckets = I18n.t("transition_landing_page.campaign_buckets")
    buckets.each do |bucket|
      bucket[:list_block] = convert_to_govspeak(bucket[:list_block])
    end
  end

  def fetch_comms
    comms = I18n.t("transition_landing_page.comms")
    comms[:links].map do |link_item|
      data_attributes = {
        track_category: "transition-landing-page",
        track_action: link_item[:link][:path],
        track_label: "News",
      }

      link_item[:link][:data_attributes] = data_attributes
    end
    comms[:video][:transcript] = convert_to_govspeak(comms[:video][:transcript]) if comms[:video]

    comms
  end

  def convert_to_govspeak(markdown)
    Govspeak::Document.new(markdown).to_html.html_safe unless markdown.nil?
  end
end
