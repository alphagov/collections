require 'fast_stemmer'

class TaxonSearch
  attr_accessor :tree, :top_level_results, :second_level_results, :results

  def initialize(q)
    @q = q
  end

  def fetch
    @results = rummager_results
    time = Benchmark.realtime do
      build_taxon_tree
    end
    p "building taxon tree took: #{time}"
    time = Benchmark.realtime do
      calculate_metrics
    end
    p "calculating metrics took: #{time}"
    time = Benchmark.realtime do
      build_results
    end
    p "building results took: #{time}"
  end


  def build_results
    @results = []

    top_level_taxons = build_top_level_taxons
    transform, mean_log = calculate_mean_log(top_level_taxons)
    total_document_including_term_count = 0
    total_document_count = 0
    top_level_taxons.each do |top_level_taxon|
      top_level_taxon.build_second_level_taxons(transform, mean_log)
      total_document_including_term_count += top_level_taxon.second_level_taxon_document_including_term_count
      total_document_count += top_level_taxon.second_level_taxon_total_document_count
    end
    second_level_idf = idf(total_document_count, total_document_including_term_count)
    all_second_level_result_page_tf_idfs = []
    top_level_taxons.each do |top_level_taxon|
      all_second_level_result_page_tf_idfs += top_level_taxon.second_level_result_tf_idfs(second_level_idf)
    end
    transform = 0
    median_transform = 0
    if all_second_level_result_page_tf_idfs.any?
      median_transform = all_second_level_result_page_tf_idfs.median_transform_twice_std
    end
    # p "TRANSFORM: #{transform}"
    p "CUTOFF: #{median_transform}"
    top_level_taxons.each do |top_level_taxon|
      top_level_taxon.filter_second_level_taxon_pages(transform, median_transform)
      @results << top_level_taxon.to_h
    end
  end

  def build_top_level_taxons
    top_level_taxons = []
    @tree.ranked_children.each do |top_level_taxon|
      top_level_taxons << TopLevelResult.new(@q, top_level_taxon)
    end
    top_level_taxons
  end

  def calculate_mean_log(top_level_taxons)
    all_children = top_level_taxons.inject([]) { |children, top_level_taxon| children += top_level_taxon.all_children_ranked; children }
    tf_idfs = all_children.inject([]){|accum, taxon_node| accum << taxon_node.tf_idf; accum }
    tf_idfs.median_log
  end

  def calculate_metrics
    total_content_count = @tree.total_content_count
    total_query_content_count = @tree.total_query_count(@q)
    tree_idf = idf(total_content_count, total_query_content_count)
    @tree.calculate_metrics(@q, tree_idf)
  end

  def idf(total_content_count, total_query_content_count)
    Math.log10(total_content_count.to_f / (1.0 + total_query_content_count.to_f))
  end

  def build_taxon_tree
    @tree = TaxonNode.new({content_id: "f3bbdec2-0e62-4520-a7fd-6ffd5d36e03a"})
    @results.each do |result|
      begin
        item = Services.content_store.content_item(result["_id"])
        if item.dig("links", "taxons")
          item["links"]["taxons"].each do |taxon|
            build_taxon_branch(taxon)
          end
        end
      rescue GdsApi::HTTPNotFound
        p "rescued"
      end
    end
  end

  def build_taxon_branch(taxon)
    parents = [taxon]
    loop do
      parent = parent(parents.last)
      if parent.nil?
        break
      else
        if parent.kind_of? Array and parent.count > 1
          parent.each do |grandparent|
            build_taxon_branch(grandparent)
          end
        else
          parents << parent.first
        end
      end
    end

    last_taxon = @tree
    parents.reverse.each do |child|
      last_taxon = last_taxon.add_child(TaxonNode.new(child))
    end
  end

  def print
    @tree.print(@q)
  end

  def parent(taxon)
    if taxon.dig("links", "parent_taxons")
      return taxon["links"]["parent_taxons"]
    end
  end

  def rummager_results
    params = {
        start: 0,
        count: 10,
        q: @q
    }
    Services.rummager.search(params)["results"]
  end
end


module Enumerable
  def sum
    self.inject(0){|accum, i| accum + i }
  end

  def mean
    self.sum/self.length.to_f
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end

  def median
    sorted = self.sort
    len = self.count
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def standard_error_of_mean
    self.standard_deviation / (Math.sqrt(self.length))
  end

  def median_transform
    (self.median - self.standard_error_of_mean).abs
  end

  def median_transform_twice_std
    (self.median.abs - (self.standard_error_of_mean * 2.5).abs).abs
  end

  def median_log
    logs = self.map{ |value| value}
    sorted_logs = logs.sort
    transform = sorted_logs.first.abs
    absolute_sorted_logs = sorted_logs.map{ |value| value + transform }
    [transform, absolute_sorted_logs.median]
  end
end


class Numeric
  def transform_mean_log(transform)
    Math.log10(self) + transform
  end
end