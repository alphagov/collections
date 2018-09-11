class TopLevelResult
  attr_accessor :all_children_ranked, :second_level_taxon_document_including_term_count, :second_level_taxon_total_document_count
  def initialize(query, taxon_node)
    @query = query
    @taxon_node = taxon_node
    @second_level_taxon_document_including_term_count = 0
    @second_level_taxon_total_document_count = 0
    @all_children_ranked = fetch_all_children_ranked
    @selected_children_ranked = []
  end

  def fetch_all_children_ranked
    ranked_children = Hash.new{ |hash, key| hash[key] = Array.new; }
    @taxon_node.all_children.each do |child|
      ranked_children[child.tf_idf] << child
    end
    ranked_children.sort.map { |child| child.second.flatten }.flatten
  end

  def build_second_level_taxons(transform, mean_log)
    @second_level_taxon_tf = 0
    @all_children_ranked.each do |child|
      if child.tf_idf.transform_mean_log(transform) < mean_log
        second_level_result = SecondLevelResult.new(@query, child)
        @selected_children_ranked << second_level_result
        @second_level_taxon_document_including_term_count += second_level_result.document_count_including_search
        @second_level_taxon_total_document_count += second_level_result.total_document_count
      end
    end
  end

  def second_level_result_tf_idfs(total_tf)
    all_tf_idfs = []
    @selected_children_ranked.each do |child|
      all_tf_idfs += child.calculate_page_tf_idfs(total_tf)
    end
    all_tf_idfs
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