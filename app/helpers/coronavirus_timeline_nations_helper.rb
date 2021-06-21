module CoronavirusTimelineNationsHelper
  def show_timeline_nations?(timeline_list)
    timeline_list.any? { |item| item["national_applicability"] }
  end

  def timeline_for_nation(timeline_list, nation)
    timeline_list.select { |item| item["national_applicability"].include?(nation) }
  end
end
