class TaxonNode
  attr_reader :children, :tf_idf, :median_child_tf_idf

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
    children.sort.map { |child| child.second }
  end

  def all_children
    children = [self.dup]
    @children.values.each do |child|
      children << child.all_children
    end
    children.flatten
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

  def calculate_metrics(query, idf)
    @tf_idf = calculate_tf_idf(query, idf)
    scores = [@tf_idf]
    @children.values.each do |child|
      child.calculate_metrics(query, idf)
      scores << child.tf_idf
    end
    @median_child_tf_idf = scores.median
  end

  def print(query)
    p "#{href}: #{query_content_count(query)}, #{@tf_idf}"
    @children.values.each do |child|
      child.print(query)
    end
  end

  def id
    @taxon["content_id"]
  end

  def calculate_tf_idf(query, idf)
    (tf(query) * idf)
  end

  def tf(query)
    (total_content_count.to_f / query_content_count(query).to_f)
  end

  def query_content_count(query)
    @query_content_count ||= fetch_query_content_count(query)
  end

  def content_count
    @content_count ||= fetch_content_count
  end

  def total_query_count(query)
    @total_query_count ||= fetch_total_query_count(query)
  end

  def fetch_total_query_count(query)
    count = query_content_count(query)
    @children.values.each do |child|
      count += child.total_query_count(query)
    end
    count
  end

  def total_content_count
    @total_content_count ||= fetch_total_content_count
  end

  def fetch_total_content_count
    count = content_count
    @children.values.each do |child|
      count += child.total_content_count
    end
    count
  end

  def fetch_query_content_count(query)
    params = {
        start: 0,
        count: 1000,
        filter_part_of_taxonomy_tree: @taxon["content_id"],
        q: query
    }
    Services.rummager.search(params)["results"].count
  end

  def fetch_content_count
    params = {
        start: 0,
        count: 1000,
        filter_part_of_taxonomy_tree: @taxon["content_id"]
    }
    Services.rummager.search(params)["results"].count
  end

  # def calculate_median(array)
  #   sorted = array.sort
  #   len = sorted.length
  #   (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  # end

  def calculate_mean(array)
    array.inject(&:+).to_f / array.count.to_f
  end
end