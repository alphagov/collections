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
end
