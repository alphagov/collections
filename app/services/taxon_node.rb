class TaxonNode
  attr_reader :children, :score, :median_child_tf_idf, :content_pages

  def initialize(taxon)
    @taxon = taxon
    @children = {}
  end

  def add_child(child_node)
    if not @children.has_key?(child_node.id)
      @children[child_node.id] = child_node
    end
    @children[child_node.id]
  end

  def ranked_children
    children = {}
    @children.values.each do |child|
      children[child.median_child_tf_idf] = child
    end
    children.sort.map { |child| child.second }.reverse
  end

  def all_children
    if children.values.any?
      children = []
      @children.values.each do |child|
        children << child.all_children
      end
      children.flatten
    else
      [self.dup]
    end
  end

  def title
    @taxon["title"]
  end

  def href
    @taxon["base_path"]
  end

  def content_id
    @taxon["content_id"]
  end

  def calculate_metrics(query)
    @score = fetch_es_score(query)
    scores = [@score]
    @children.values.each do |child|
      child.calculate_metrics(query)
      scores << child.score
    end
    @median_child_tf_idf = scores.median
  end

  def print(query)
    p "#{href.to_s.gsub("/", ",")},#{@score}"
    @children.values.each do |child|
      child.print(query)
    end
  end

  def id
    @taxon["content_id"]
  end

  def calculate_tf_idf(query)
    fetch_es_score(query)
  end

  def fetch_es_score(query)
    return -1000 unless id
    params = {
        start: 0,
        count: 10,
        filter_part_of_taxonomy_tree: @taxon["content_id"],
        q: query
    }

    @content_pages = Services.rummager.search(params)["results"]
    scores = @content_pages.map{ |result| result["es_score"]}
    if scores.any?
      scores.median
    else
      -1000
    end
  end
end
