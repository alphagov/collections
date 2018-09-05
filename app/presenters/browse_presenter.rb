class BrowsePresenter
  include ActionView::Helpers::UrlHelper

  def top_level_taxons
    # Retrieve the root taxon (GOV.UK homepage)
    top_level_taxons = Services.content_store.content_item('/').dig('links', 'level_one_taxons').map do |top_level_taxon|
      {
        title: top_level_taxon["title"],
        base_path: top_level_taxon["base_path"],
        popular_content: most_popular_content(top_level_taxon["content_id"])
      }
    end

    top_level_taxons.sort_by {|taxon_hash| taxon_hash[:title]}
  end

  def all_supergroups
    %w(services guidance_and_regulation news_and_communications policy_and_engagement research_and_statistics transparency other)
  end

  def associated_taxons(base_path, parent_taxon_path)
    associated_taxons = Services.content_store.content_item(base_path).dig('links', 'taxons')

    associated_taxons.each do |taxon|
      if parent_taxon_path.eql?("/business-and-industry")
        associated_taxons.delete_if {|taxon| !taxon["base_path"].include?(parent_taxon_path) && !taxon["base_path"].include?("/business") }
      elsif parent_taxon_path.eql?("/defence-and-armed-forces")
        associated_taxons.delete_if {|taxon| !taxon["base_path"].include?(parent_taxon_path) && !taxon["base_path"].include?("/defence") }
      elsif parent_taxon_path.eql?("/government/all")
        associated_taxons.delete_if {|taxon| !taxon["base_path"].include?(parent_taxon_path) && !taxon["base_path"].include?("/government") }
      elsif parent_taxon_path.eql?("/work")
        associated_taxons.delete_if {|taxon| !taxon["base_path"].include?(parent_taxon_path) && !taxon["base_path"].include?("/employment") }
      else
        associated_taxons.delete_if {|taxon| !taxon["base_path"].include?(parent_taxon_path) && !taxon["base_path"].include?("/business") }
      end
    end

    taxon_links = associated_taxons.map do |taxon|
      link_to taxon["title"], taxon["base_path"]
    end

    taxon_links.to_sentence.html_safe
  end

private

  def most_popular_content(taxon_id)
    MostPopularContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: false)
  end
end
