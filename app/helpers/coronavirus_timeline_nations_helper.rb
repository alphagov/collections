module CoronavirusTimelineNationsHelper
  def show_timeline_nations?(timeline_list)
    timeline_list.any? { |item| item["national_applicability"] }
  end

  def timeline_for_nation(timeline_list, nation)
    timeline_list.select { |item| item["national_applicability"].include?(nation) }
  end

  def uk_wide?(national_applicability)
    uk_country_list = %w[england wales northern_ireland scotland]
    uk_country_list.sort == national_applicability.uniq.sort
  end

  def display_country(selected_country = "england")
    uk_country_list = %w[england wales northern_ireland scotland]

    return "england" unless uk_country_list.include?(selected_country)

    selected_country
  end
end
