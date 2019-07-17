module PaginationHelper
  def paginate(results, wrap_in_results_array)
    if wrap_in_results_array
      {
        results: results,
        previous_page_url: previous_page_url,
        next_page_url: next_page_url,
        current_page: current_page,
        total: total_results,
        pages: number_of_pages,
        page_size: results_per_page,
        start_index: start_index,
        _response_info: response_info,
      }.compact
    else
      results[0][:_response_info] = response_info
      results[0]
    end
  end

private

  def current_page_url
    return current_url_without_parameters if first_page? && last_page?

    "#{current_url_without_parameters}?page=#{current_page}"
  end

  def previous_page_url
    unless first_page?
      "#{current_url_without_parameters}?page=#{prev_page}"
    end
  end

  def next_page_url
    unless last_page?
      "#{current_url_without_parameters}?page=#{next_page}"
    end
  end

  def number_of_pages
    (total_results.to_f / results_per_page).ceil
  end

  def start_index
    (current_page - 1) * results_per_page + 1
  end

  def prev_page
    [current_page - 1, 1].max
  end

  def next_page
    [current_page + 1, number_of_pages].min
  end

  def first_page?
    current_page == 1
  end

  def last_page?
    current_page == number_of_pages
  end

  def links
    links = []
    links << { href: previous_page_url, rel: "previous" } if previous_page_url
    links << { href: next_page_url, rel: "next" } if next_page_url
    links << { href: current_page_url, rel: "self" }
    links
  end

  def response_info
    {
      status: "ok",
      links: links,
    }
  end
end
