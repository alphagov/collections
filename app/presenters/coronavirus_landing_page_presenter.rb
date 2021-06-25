class CoronavirusLandingPagePresenter
  COMPONENTS = %w[
    header_section
    announcements_label
    announcements
    see_all_announcements_link
    risk_level
    nhs_banner
    sections
    sections_heading
    additional_country_guidance
    topic_section
    statistics_section
    notifications
    page_header
    timeline
  ].freeze

  UK_COUNTRY_LIST = %w[england northern_ireland scotland wales].freeze

  def initialize(content_item, selected_country = nil)
    COMPONENTS.each do |component|
      define_singleton_method component do
        content_item["details"][component]
      end
    end

    @selected_country = selected_country
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

  def show_timeline_nations?
    timeline["list"].any? { |item| item["national_applicability"] }
  end

  def timelines_for_nation
    UK_COUNTRY_LIST.map do |nation|
      [nation, timeline_for_nation(nation)]
    end
  end

  def timeline_nations_items
    selected_country = UK_COUNTRY_LIST.include?(@selected_country) ? @selected_country : "england"

    UK_COUNTRY_LIST.map do |value|
      {
        value: value,
        text: value.titleize,
        checked: selected_country == value,
        data_attributes: {
          track_category: "pageElementInteraction",
          track_action: "TimelineNation",
          track_label: value.titleize,
        },
      }
    end
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
    announcement_text = ApplicationController.render partial: "coronavirus_landing_page/components/shared/announcements",
                                                     locals: {
                                                       announcements: content_item["details"]["announcements"],
                                                     }
    question_and_answer_schema("Announcements", announcement_text)
  end

  def build_sections_schema(content_item)
    question_and_answers = []
    content_item["details"]["sections"].each do |section|
      question = section["title"]
      answers_text = ApplicationController.render partial: "coronavirus_landing_page/components/shared/section", locals: { section: section }
      question_and_answers.push question_and_answer_schema(question, answers_text)
    end
    question_and_answers
  end

  def timeline_for_nation(nation)
    entries = timeline["list"].select { |item| item["national_applicability"].include?(nation) }

    entries.map do |entry|
      entry.merge!("tags" => timeline_nation_tags(entry["national_applicability"]))
    end
  end

  def timeline_nation_tags(national_applicability)
    if uk_wide?(national_applicability)
      "<strong class='govuk-tag govuk-tag--blue'>UK Wide</strong>"
    else
      nation_tags = national_applicability.map do |nation|
        "<strong class='govuk-tag govuk-tag--blue'>#{nation.titleize}</strong>"
      end

      nation_tags.join(" ")
    end
  end

  def uk_wide?(national_applicability)
    UK_COUNTRY_LIST.sort == national_applicability.uniq.sort
  end
end
