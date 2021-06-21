module CoronavirusTimelineNationsHelper
  UK_COUNTRY_LIST = %w[england northern_ireland scotland wales].freeze

  def show_timeline_nations?(timeline_list)
    timeline_list.any? { |item| item["national_applicability"] }
  end

  def timeline_for_nation(timeline_list, nation)
    timeline_list.select { |item| item["national_applicability"].include?(nation) }
  end

  def uk_wide?(national_applicability)
    UK_COUNTRY_LIST.sort == national_applicability.uniq.sort
  end

  def display_country(selected_country = "england")
    return "england" unless UK_COUNTRY_LIST.include?(selected_country)

    selected_country
  end
end
