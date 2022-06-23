module TopicalEventsHelper
  def search_url(content_type, slug)
    base_path(content_type) + query_params(content_type, slug).to_param
  end

private

  def base_path(content_type)
    { publication: "/search/all?",
      consultation: "/search/policy-papers-and-consultations?",
      announcement: "/search/news-and-communications?" }[content_type]
  end

  def query_params(content_type, slug)
    case content_type
    when :publication
      {
        topical_events: [slug],
      }
    when :consultation
      {
        content_store_document_type: %w[open_consultations closed_consultations],
        topical_events: [slug],
      }
    when :announcement
      {
        topical_events: [slug],
      }
    end
  end
end
