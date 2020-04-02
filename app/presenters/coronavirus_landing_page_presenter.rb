class CoronavirusLandingPagePresenter
  COMPONENTS = %w(live_stream stay_at_home guidance announcements_label announcements nhs_banner sections topic_section country_section notifications).freeze

  def initialize(content_item)
    COMPONENTS.each do |component|
      define_singleton_method component do
        content_item["details"][component]
      end
    end
  end

  def show_live_stream?
    live_stream && live_stream["show_video"] == true
  end

  def faq_schema(content_item)
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "name": content_item["title"],
      "description": content_item["description"],
      "mainEntity": build_faq_main_entity(content_item),
    }
  end

private

  def build_faq_main_entity(content_item)
    question_and_answers = []
    question_and_answers.push build_announcements_schema(content_item)
    question_and_answers.concat build_sections_schema(content_item)
  end

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

  def build_announcements_schema(content_item)
    announcement_text = ApplicationController.render partial: "coronavirus_landing_page/announcements",
      locals: {
        announcements: content_item["details"]["announcements"],
      }
    question_and_answer_schema("Announcements", announcement_text)
  end

  def build_sections_schema(content_item)
    question_and_answers = []
    content_item["details"]["sections"].each do |section|
      question = section["title"]
      answers_text = ApplicationController.render partial: "coronavirus_landing_page/section", locals: { section: section }
      question_and_answers.push question_and_answer_schema(question, answers_text)
    end
    question_and_answers
  end
end
