module CoronavirusTimelineNationsHelper
  UK_COUNTRY_LIST = %w[england northern_ireland scotland wales].freeze

  def show_timeline_nations?(timeline_list)
    timeline_list.any? { |item| item["national_applicability"] }
  end

  def timeline_for_nation(timeline_list, nation)
    timeline_list.select { |item| item["national_applicability"].include?(nation) }
  end

  def timeline_nations_items(selected_country = nil)
    selected_country = "england" unless UK_COUNTRY_LIST.include?(selected_country)

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
