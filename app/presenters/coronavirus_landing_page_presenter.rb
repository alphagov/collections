class CoronavirusLandingPagePresenter
  COMPONENTS = %w[
    header_section
    sections
  ].freeze

  def initialize(content_item)
    COMPONENTS.each do |component|
      define_singleton_method component do
        content_item["details"][component]
      end
    end
  end

  def faq_schema(content_item)
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "name": content_item["title"],
      "description": content_item["description"],
      "mainEntity": build_sections_schema(content_item),
    }
  end

  def title
    "COVID-19"
  end

  def metadata
    {
      title: "COVID-19: guidance and support",
      description: "Find information on COVID-19, including guidance and support.",
    }
  end

  def additional_country_guidance
    { links: [
      {
        label: "Guidance for Scotland",
        url: "https://www.gov.scot/coronavirus-covid-19/",
      },
      {
        label: "Guidance for Wales",
        url: "https://gov.wales/coronavirus",
      },
      {
        label: "Guidance for Northern Ireland",
        url: "https://www.nidirect.gov.uk/campaigns/coronavirus-covid-19",
      },
    ] }
  end

  def topic_section
    { links: [
      {
        label: "Guidance and regulation about COVID-19",
        url: "/search/all?order=updated-newest&level_one_taxon=8124ead8-8ebc-4faf-88ad-dd5cbcc92ba8&level_two_taxon=5b7b9532-a775-4bd2-a3aa-6ce380184b6c&content_purpose_supergroup%5B%5D=guidance_and_regulation",
      },
      {
        label: "News and communications about COVID-19",
        url: "/search/all?order=updated-newest&level_one_taxon=8124ead8-8ebc-4faf-88ad-dd5cbcc92ba8&level_two_taxon=5b7b9532-a775-4bd2-a3aa-6ce380184b6c&content_purpose_supergroup%5B%5D=news_and_communications",
      },
      {
        label: "Research and statistics about COVID-19",
        url: "/search/all?order=updated-newest&level_one_taxon=8124ead8-8ebc-4faf-88ad-dd5cbcc92ba8&level_two_taxon=5b7b9532-a775-4bd2-a3aa-6ce380184b6c&content_purpose_supergroup%5B%5D=research_and_statistics",
      },
      {
        label: "Policy papers and consultations about COVID-19",
        url: "/search/all?order=updated-newest&level_one_taxon=8124ead8-8ebc-4faf-88ad-dd5cbcc92ba8&level_two_taxon=5b7b9532-a775-4bd2-a3aa-6ce380184b6c&content_purpose_supergroup%5B%5D=policy_and_engagement",
      },
      {
        label: "Transparency and freedom of information releases about COVID-19",
        url: "/search/all?order=updated-newest&level_one_taxon=8124ead8-8ebc-4faf-88ad-dd5cbcc92ba8&level_two_taxon=5b7b9532-a775-4bd2-a3aa-6ce380184b6c&content_purpose_supergroup%5B%5D=transparency",
      },
      {
        label: "Summary of COVID-19 testing, cases and vaccinations data",
        url: "https://ukhsa-dashboard.data.gov.uk/respiratory-viruses/covid-19",
      },
      {
        label: "COVID-19 legislation on legislation.gov.uk",
        url: "https://www.legislation.gov.uk/coronavirus",
      },
      {
        label: "COVID-19 press conferences on YouTube",
        url: "https://www.youtube.com/user/Number10gov/videos",
      },
      {
        label: "Slides, datasets and transcripts from press conferences",
        url: "/government/collections/slides-and-datasets-to-accompany-coronavirus-press-conferences",
      },
    ] }
  end

private

  def question_and_answer_schema(question, answer)
    {
      "@type": "Question",
      "name": question,
      "acceptedAnswer": {
        "@type": "Answer",
        "text": answer,
      },
    }
  end

  def build_sections_schema(content_item)
    question_and_answers = []
    content_item["details"]["sections"].each do |section|
      question = section["title"]
      answers_text = ApplicationController.render partial: "coronavirus_landing_page/components/shared/section", locals: { section: }
      question_and_answers.push question_and_answer_schema(question, answers_text)
    end
    question_and_answers
  end
end
