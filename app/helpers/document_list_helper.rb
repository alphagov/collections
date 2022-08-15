module DocumentListHelper
  def search_url(page_type, content_type, slug)
    case page_type
    when :topical_event
      base_path(content_type) + topical_event_query_params(content_type, slug).to_param
    when :world_location_news
      base_path(content_type) + world_location_news_query_params(content_type, slug).to_param
    end
  end

private

  def base_path(content_type)
    { announcement: "/search/news-and-communications?",
      consultation: "/search/policy-papers-and-consultations?",
      detailed_guidance: "/search/all?",
      latest: "/search/all?",
      publication: "/search/all?",
      statistic: "/search/research-and-statistics?" }[content_type]
  end

  def topical_event_query_params(content_type, slug)
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

  def world_location_news_query_params(content_type, slug)
    case content_type
    when :latest
      {
        order: "updated-newest",
        world_locations: [slug],
      }
    when :publication
      {
        content_purpose_supergroup: %w[guidance_and_regulation policy_and_engagement transparency],
        order: "updated-newest",
        world_locations: [slug],
      }
    else
      {
        world_locations: [slug],
      }
    end
  end
end
