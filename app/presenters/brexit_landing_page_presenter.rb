require 'yaml'
require 'govspeak'

class BrexitLandingPagePresenter
  attr_reader :taxon, :buckets
  delegate(
    :title,
    :base_path,
    to: :taxon
  )

  def initialize(taxon)
    @taxon = taxon
    @buckets = fetch_buckets
  end

  def supergroup_sections
    brexit_sections = SupergroupSections::BrexitSections.new(taxon.content_id, taxon.base_path).sections
    brexit_sections.map do |section|
      {
        text: I18n.t(section[:name], scope: :content_purpose_supergroup, default: section[:title]),
        path: section[:see_more_link][:url],
        data_attributes: section[:see_more_link][:data]
      }
    end
  end

  def brexit?
    true
  end

private

  def fetch_buckets
    buckets = YAML.load_file('config/brexit_campaign_buckets.yml')

    buckets.each do |bucket|
      bucket.fetch("items", []).each do |link|
        link.symbolize_keys!
        link[:description] = link[:description].html_safe
      end
      bucket["block"] = Govspeak::Document.new(bucket["block"]).to_html.html_safe unless bucket['block'].nil?
    end
  end
end
