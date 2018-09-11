class SecondLevelResult
  attr_accessor :document_count_including_search, :total_document_count
  def initialize(query, taxon_node)
    @taxon_node = taxon_node
    @query = query
    @document_count_including_search = 0
    @total_document_count = 0
    @stemmed_query = fetch_stemmed_query
    @content = fetch_content
    @content_items = fetch_content_items
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
      @filtered_content_items.sort_by{ |content_item| content_item[:tf_idf] }.each do |content_item|
        result[:pages] << {
            title: content_item[:title],
            link: content_item[:link]
        }
      end
    end
    result
  end


  def fetch_content
    params = {
      start: 0,
      count: 10,
      q: @query,
      filter_part_of_taxonomy_tree: @taxon_node.content_id,
      fields: ['title', 'link']
    }
    Services.rummager.search(params)["results"]
  end

  def fetch_content_items
    content_items = []
    @content.each do |result|
      content_item = Services.content_store.content_item(result["_id"]).to_h
      content_item_text = stem(content_item.to_s)
      process_content_item_text(content_item_text)
      item = {
        title: content_item["title"],
        link: content_item["base_path"],
        text: content_item_text
      }
      content_items << item
    end
    content_items
  end

  def stem(text)
    texts = ActionView::Base.full_sanitizer.sanitize(text.to_s.gsub("\\n", "").gsub("\n", "").gsub("\\", "")).split(" ")
    texts.map{ |word| word.stem }.join(" ")
  end

  def process_content_item_text(text)
    split_text = text.split(" ")
    @stemmed_query.each do |search_word|
      if split_text.include?(search_word)
        @document_count_including_search += 1
        next
      end
    end
    @total_document_count += 1
  end

  def calculate_page_tf_idfs(total_idf)
    tf_idfs = []
    @content_items.each do |content_item|
      tf = calculate_tf(content_item)
      if tf
        tf_idf = (total_idf * tf).abs
        tf_idfs << tf_idf
        content_item[:tf_idf] = tf_idf
      end
    end
    tf_idfs
  end

  def filter_pages(transform, median_transform)
    @filtered_content_items = []
    @content_items.each do |content_item|
      if content_item.has_key?(:tf_idf) and content_item[:tf_idf] <= median_transform
        @filtered_content_items << content_item
      end
    end
  end

  def calculate_tf(content_item)
    words = content_item[:text].split(" ")
    number_search_term_occurances = 0
    words.each do |word|
      if @stemmed_query.include?(word)
        number_search_term_occurances += 1
      end
    end
    return false unless number_search_term_occurances > 0
    (words.count.to_f / number_search_term_occurances.to_f).abs
  end
end