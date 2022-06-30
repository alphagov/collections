module TopicalEventsHelper
  def search_url(content_type, slug)
    base_path(content_type) + query_params(content_type, slug).to_param
  end

private

  def base_path(content_type)
    { announcement: "/search/news-and-communications?",
      consultation: "/search/policy-papers-and-consultations?",
      detailed_guidance: "/search/all?",
      latest: "/search/all?",
      publication: "/search/all?" }[content_type]
  end

  def query_params(content_type, slug)
    case content_type
    when :consultation
      {
        content_store_document_type: %w[open_consultations closed_consultations],
        topical_events: [slug],
      }
    when :detailed_guidance
      {
        content_purpose_supergroup: "guidance_and_regulation",
        topical_events: [slug],
      }
    when :latest
      {
        order: "updated-newest",
        topical_events: [slug],
      }
    else
      {
        topical_events: [slug],
      }
    end
  end
end
