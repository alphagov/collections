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
      supergroup_title = I18n.t(section[:name], scope: :content_purpose_supergroup, default: section[:title])
      {
        text: supergroup_title,
        path: section[:see_more_link][:url],
        data_attributes: section[:see_more_link][:data],
        aria_label: supergroup_title + " related to Brexit",
      }
    end
  end

  def email_path
    base_path.split(".").first
  end

private

  def fetch_buckets
    buckets = YAML.load_file("config/brexit_campaign_buckets/#{I18n.locale}.yml")

    buckets.each do |bucket|
      bucket["list_block"] = convert_to_govspeak(bucket["list_block"])
    end
  end

  def convert_to_govspeak(markdown)
    Govspeak::Document.new(markdown).to_html.html_safe unless markdown.nil?
  end
end
