class BrowsePresenter
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

private

  def most_popular_content(taxon_id)
    MostPopularContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: false)
  end
end
