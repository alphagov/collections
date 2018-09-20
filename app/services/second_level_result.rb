class SecondLevelResult
  include ActionView::Helpers::NumberHelper

  attr_accessor :content_page_scores
  def initialize(query, taxon_node)
    @taxon_node = taxon_node
    @query = query
    @content_page_scores = []
    @content_items = build_content_items
  end

  def fetch_stemmed_query
    @query.split(" ").map { |word| word.stem }
  end

  def to_h
    result = {
        title: @taxon_node.title,
        href: @taxon_node.href
    }

    if @filtered_content_items.any?
      result[:pages] = []
      @filtered_content_items.sort_by{ |content_item| content_item[:score] }.reverse.each do |content_item|
        result[:pages] << {
            title: content_item[:title],
            link: content_item[:link]
        }
      end
    end
    result
  end

  def build_content_items
    content_items = []
    @taxon_node.content_pages.each do |page|
      item = {
          title: page["title"],
          link: page["link"],
          score: page["es_score"]
      }
      content_items << item
      @content_page_scores << page["es_score"]
    end
    content_items
  end

  def filter_pages(transform, median_transform)
    @filtered_content_items = []
    @content_items.each do |content_item|
      # p "#{content_item[:title]},#{number_with_precision(Math.log10(content_item[:score]), precision: 12)}"
      if content_item.has_key?(:score) and Math.log10(content_item[:score]) >= median_transform
        @filtered_content_items << content_item
      end
    end
  end

end