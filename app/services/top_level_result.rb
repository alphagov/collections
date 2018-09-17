class TopLevelResult
  attr_accessor :all_children_ranked, :second_level_content_page_scores
  def initialize(query, taxon_node)
    @query = query
    @taxon_node = taxon_node
    @second_level_content_page_scores = []
    @all_children_ranked = fetch_all_children_ranked
    @selected_children_ranked = []
  end

  def fetch_all_children_ranked
    ranked_children = Hash.new{ |hash, key| hash[key] = Array.new; }
    @taxon_node.all_children.each do |child|
      ranked_children[child.score] << child
    end
    ranked_children.sort.map { |child| child.second.flatten }.flatten.reverse
  end

  def build_second_level_taxons(transform, mean_log)
    @second_level_taxon_tf = 0
    @all_children_ranked.each do |child|
      if child.score.transform_mean_log(transform) < mean_log
        second_level_result = SecondLevelResult.new(@query, child)
        @selected_children_ranked << second_level_result
        @second_level_content_page_scores += second_level_result.content_page_scores
      end
    end
  end

  def filter_second_level_taxon_pages(transform, mean_log)
    @selected_children_ranked.each do |child|
      child.filter_pages(transform, mean_log)
    end
  end

  def to_h
    selected_children_hashes = []
    @selected_children_ranked.each do |child|
      selected_children_hashes << child.to_h
    end
    {
      topic_title: @taxon_node.title,
      topic_href: @taxon_node.href,
      sub_topics: selected_children_hashes,
      all_ranked_children: @all_children_ranked
    }
  end
end