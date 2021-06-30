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

  UK_NATIONS = %w[england northern_ireland scotland wales].freeze

  attr_reader :selected_nation

  def initialize(content_item, selected_nation = nil)
    COMPONENTS.each do |component|
      define_singleton_method component do
        content_item["details"][component]
      end
    end

    @selected_nation = UK_NATIONS.include?(selected_nation) ? selected_nation : "england"
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

  def timeline_nations_items
    UK_NATIONS.map do |value|
      {
        value: value,
        text: value.titleize,
        checked: selected_nation == value,
        data_attributes: {
          module: "gem-track-click",
          track_category: "pageElementInteraction",
          track_action: "TimelineNation",
          track_label: value.titleize,
        },
      }
    end
  end

  def timelines_for_nation
    UK_NATIONS.map do |nation|
      [nation, timeline_for_nation(nation)]
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
      "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>UK Wide</strong>".html_safe
    else
      nation_tags = national_applicability.map do |nation|
        "<strong class='govuk-tag govuk-tag--blue covid-timeline__tag'>#{nation.titleize}</strong>"
      end

      nation_tags.join(" ").html_safe
    end
  end

  def uk_wide?(national_applicability)
    UK_NATIONS.sort == national_applicability.uniq.sort
  end
end
